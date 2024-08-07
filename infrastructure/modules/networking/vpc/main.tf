resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  instance_tenancy = "default"

  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

locals {
  cidr_blocks = cidrsubnets(var.cidr_block, 1, 1)

  public_cidr_block  = local.cidr_blocks[0]
  private_cidr_block = local.cidr_blocks[1]
  availability_zones = var.availability_zones
}