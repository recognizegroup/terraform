variable "zone_name" {
  type        = string
  description = "The DNS zone name to add the records to."
}

variable "records" {
  type = list(object({
    name            = string,
    value           = string,
    type            = string,
    ttl             = number,
    priority        = optional(number),
    proxied         = optional(bool),
    allow_overwrite = optional(bool)
  }))
  description = "A list containing settings to create Cloudflare DNS records."
  default     = []
}
