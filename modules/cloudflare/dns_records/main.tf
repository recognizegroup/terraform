terraform {
  required_version = ">=1.3.0"

  // FIXME: Is hier wel azurerm nodig?
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.14.0"
    }
  }

  backend "azurerm" {}
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
