variable "region" {
  type = string
}

variable "name" {
  description = "Used to generate names of resources as they will appears in the AWS console"
  type        = string
}

variable "environment" {
  description = "All resources generated are generated with a tag to their environment"
  type        = string
}

variable "cidr_block" {
  description = "The VPC cidr block"
  type        = string
}

variable "availability_zones" {
  type = list(string)
}