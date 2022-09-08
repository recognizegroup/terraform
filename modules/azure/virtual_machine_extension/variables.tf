variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}


variable "virtual_machine_id" {
  type = string
  description = "virtual machine id"
}

variable "list_of_file_uris" {
    type = list(string)
    description = "uris for all the file that have to be downloaded"
}