variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet."
}

variable "virtual_machine_name" {
  type        = string
  description = "The name of the virtual machine."
}

variable "virtual_machine_size" {
  type        = string
  description = "The size of the virtual machine."
  default     = "Standard_B2s"
}

variable "timezone" {
  type        = string
  description = "The timezone of the virtual machine."
  default     = "W. Europe Standard Time"
}

variable "virtual_machine_image_publisher" {
  type        = string
  description = "The publisher of the virtual machine image."
  default     = "MicrosoftWindowsDesktop"
}

variable "virtual_machine_image_offer" {
  type        = string
  description = "The offer of the virtual machine image."
  default     = "Windows-11"
}

variable "virtual_machine_image_sku" {
  type        = string
  description = "The SKU of the virtual machine image."
  default     = "win11-22h2-pro"
}

variable "virtual_machine_image_version" {
  type        = string
  description = "The version of the virtual machine image."
  default     = "latest"
}

variable "enable_public_access" {
  type        = bool
  description = "Enable public access for the virtual machine."
  default     = false
}

variable "allow_rdp_ip" {
  type        = string
  description = "The IP address to allow RDP access from."
  default     = ""
}

variable "power_automate_desktop_installer_uri" {
  type        = string
  description = "The URI of the Power Automate Desktop installer."
  default     = "https://go.microsoft.com/fwlink/?linkid=2102613"
}

