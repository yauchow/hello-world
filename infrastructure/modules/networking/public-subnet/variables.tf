variable "environment" {
  description = "The Definitiv environment used to tag the subnet"
  type        = string
}

variable "vpc" {
  description = "The VPC associated with the subnet"
  type = object({
    id = string
  })
}

variable "route_table_id" {
  description = "The public routing table associated with the subnet"
  type        = string
}

variable "cidr_block" {
  description = "Subnet's cidr_block"
  type        = string
}

variable "availability_zone" {
  description = "Availablity zone for subnet"
  type        = string
}

variable "eip_allocation_id" {
  description = "Aws EIP"
  type        = string
}

variable "assign_eip" {
  type = bool
}