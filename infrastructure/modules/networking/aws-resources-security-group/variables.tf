variable "region" {
  type = string
}

variable "environment" {
  description = "The Definitiv environment used to tag the subnet"
  type        = string
}

variable "vpc" {
  description = "The VPC the security group is applied to"
}

variable "subnets" {
  description = "Subnets that require access to AWS Resources"
  type        = list(string)
}

variable "private_route_tables" {
  description = "Private route tables"
  type        = list(string)

}