variable "command" {
  type        = string
  description = "The command to be executed."
}

variable "working_dir" {
  type        = string
  description = "The working directory of the command being executed"
  default = "."
}

variable "interpreter" {
  type = set(string)
  description = "The shell to execute the command in, like /bin/sh or powershell"
}
