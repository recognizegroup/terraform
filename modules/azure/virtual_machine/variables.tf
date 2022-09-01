variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "nw_resource_group_name" {
  type        = string
  description = "Name of the networking resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the the virtual network."
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet."
}

variable "network_interface_name" {
  type        = string
  description = "Name of the network inferface."
}

variable "ip_configuration_name" {
  type        = string
  description = "Name of the network interface ip configuration."
}

variable "private_ip_address_allocation" {
  type        = string
  description = "Type of the network interface allocation, Dynamic or Static."
}

variable "private_ip_address" {
  type        = string
  description = "The private ip address of the network inferface."
}

variable "virtual_machine_name" {
  type        = string
  description = "Name of the virtual machine."
}

variable "virtual_machine_size" {
  type        = string
  description = "Size of the virtual machine."
}

variable "os_disk_name" {
  type        = string
  description = "Name of the os disk to create."
}

variable "os_disk_caching" {
  type        = string
  description = "Specifies the caching requirements for the disk."
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "Disk type of the managed disk."
  default     = "Standard_LRS"
}

variable "enable_guest_agent" {
  type        = bool
  description = "Installs an Azure VM agent."
  default     = true
}

variable "enable_auto_updates" {
  type        = bool
  description = "Enables automatic system upgrades."
  default     = true
}

variable "image_publisher" {
  type        = string
  description = "Specifies the publisher of the image used to create the virtual machine."
}

variable "image_offer" {
  type        = string
  description = "Specifies the offer of the image used to create the virtual machine."
}

variable "image_sku" {
  type        = string
  description = "Specifies the SKU of the image used to create the virtual machine."
}

variable "image_version" {
  type        = string
  description = "Specifies the version of the image used to create the virtual machine."
}

variable "computer_name" {
  type        = string
  description = "Name of the computer."
}

variable "timezone" {
  type        = string
  description = "Operating system timezone."
  default     = "Central European Standard Time"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault."
}

variable "vm_user_secret_name" {
  type        = string
  description = "Secret containing the admin user for the vm."
}

variable "vm_password_secret_name" {
  type        = string
  description = "Secret containing the admin password for the vm."
}

variable "license_type" {
  type        = string //None, Windows_Client, Windows_Server
  description = "Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine."
  default     = null
}

variable "requires_plan" {
  type        = bool
  description = "Third party images might requires plan specification for license aceptance, many Microsoft resource do not need them"
  default     = true
}
