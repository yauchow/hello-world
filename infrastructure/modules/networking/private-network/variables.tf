variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "base_cidr_block" {
  type = string
}

variable "nat_gateway_id" {
  description = "The id nat gateway id"
  type        = string
}

variable "availability_zones" {
  description = "The list of availability zones to create subnets for"
  type        = list(string)
}