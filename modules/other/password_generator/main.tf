terraform {
  required_version = "~> 1.3"
}

resource "random_password" "password" {
  length           = var.password_length
  special          = true
  override_special = "_%@"
  keepers          = var.password_keeper
  min_lower        = var.min_lower
  min_upper        = var.min_upper
  min_numeric      = var.min_numeric
  min_special      = var.min_special
}
