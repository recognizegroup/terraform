terraform {
  required_version = "~> 1.3"
}

resource "null_resource" "local_execute_code" {
  provisioner "local-exec" {
    command     = var.command
    working_dir = var.working_dir
    interpreter = var.interpreter
  }
  triggers = {
    always_run = timestamp()
  }
}

