variable "environment" {
  type = string
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "cidr_block" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "route_table_id" {
  type = string
}