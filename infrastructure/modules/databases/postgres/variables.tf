variable "vpc" {
  type = object({
    id              = string
    private_subnets = list(string)
  })
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "username" {
  type    = string
  default = "dbuser"
}