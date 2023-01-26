
variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "query_pack_name"{
  type = string
  description = "The name of the Query Pack resource that will store the Individual Queries"
}

variable "resource_group_name" {
  type = string
  description = "Resource group where the query pack will be stored"
}

variable "query_files" {
  type = list(object({
    name = string,
    file_location = string 
    categories = optional(list(string)) // List of categories were query should be listed
  }))
  description = "list of files that contains queries descriptions with a name for this query"
  default = null
}