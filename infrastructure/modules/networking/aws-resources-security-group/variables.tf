variable "environment" {
  description = "The Definitiv environment used to tag the subnet"
  type        = string
}

variable "vpc" {
  description = "The VPC the security group is applied to"
  type        = string
}

variable "subnets" {
  description = "Subnets that require access to AWS Resources"
  type        = list(string)
}