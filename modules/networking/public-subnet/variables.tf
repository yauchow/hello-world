variable "name" {
  description = "Name of subnet as is appears in the AWS console"
  type        = string
}

variable "environment" {
  description = "The Definitiv environment used to tag the subnet"
  type        = string
}

variable "vpc_id" {
  description = "The VPC associated with the subnet"
  type        = string
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