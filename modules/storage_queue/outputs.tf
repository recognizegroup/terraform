variable "queue_names" {
  type        = set(string)
  description = "Add predefined queue names in this storage."
  default     = []
}