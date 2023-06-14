terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "public_ip" {
  count = var.enable_public_access ? 1 : 0

  name                = "public-ip-${var.virtual_machine_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "network_interface" {
  name                = "nic-${var.virtual_machine_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_access ? azurerm_public_ip.public_ip[0].id : null
  }
}

resource "azurerm_network_security_group" "nsg" {
  count = var.enable_public_access ? 1 : 0

  name                = "nsg-${var.virtual_machine_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = var.allow_rdp_ip_prefixes
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  count = var.enable_public_access ? 1 : 0

  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

resource "random_password" "vm_user_password" {
  length      = 16
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                     = var.virtual_machine_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  size                     = var.virtual_machine_size
  computer_name            = var.virtual_machine_name
  admin_username           = "adminuser"
  admin_password           = random_password.vm_user_password.result
  timezone                 = var.timezone
  provision_vm_agent       = true
  enable_automatic_updates = true
  network_interface_ids    = [azurerm_network_interface.network_interface.id]

  source_image_reference {
    publisher = var.virtual_machine_image_publisher
    offer     = var.virtual_machine_image_offer
    sku       = var.virtual_machine_image_sku
    version   = var.virtual_machine_image_version
  }

  os_disk {
    name                 = "osdisk-${var.virtual_machine_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Install Power Automate Desktop
  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = <<EOF
      <FirstLogonCommands>
    <SynchronousCommand>
    <CommandLine>%SYSTEMROOT%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -Command "&amp; { $downloadUrl = '${var.power_automate_desktop_installer_uri}'; $outputFile = \"$env:TEMP\Setup.Microsoft.PowerAutomate.exe\"; $client = New-Object System.Net.WebClient; $client.DownloadFile($downloadUrl, $outputFile); Start-Process -FilePath $outputFile -ArgumentList '-Silent -Install -ACCEPTEULA' -Wait }"</CommandLine>
      <Description>Install PowerAutomate Desktop</Description>
      <Order>1</Order>
    </SynchronousCommand>
  </FirstLogonCommands>
EOF
  }

  identity {
    type = "SystemAssigned"
  }
}
