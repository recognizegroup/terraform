terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = ">=3.6.0"
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.14.0"
    }
  }

  backend "azurerm" {}

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

provider "cloudflare" {}

data "cloudflare_zone" "zone" {
  name = var.zone_name
}

resource "cloudflare_record" "record" {
  for_each        = { for idx, rec in var.records : rec.name => rec }
  zone_id         = data.cloudflare_zone.zone.id
  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
  ttl             = each.value.ttl
  priority        = each.value.priority
  proxied         = each.value.proxied
  allow_overwrite = each.value.allow_overwrite
}
