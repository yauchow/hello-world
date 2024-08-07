locals {
  subnets = cidrsubnets(var.base_cidr_block, [for i in var.availability_zones : ceil(length(var.availability_zones) / 2)]...)
}

resource "aws_eip" "public_ip" {
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.vpc.id
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_route_table" "public_route_table" {

  vpc_id = var.vpc.id
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

module "public_subnets" {
  source = "../public-subnet"

  count = length(local.subnets)

  assign_eip        = count.index == 0
  vpc               = var.vpc
  availability_zone = var.availability_zones[count.index]
  cidr_block        = local.subnets[count.index]
  environment       = var.environment
  route_table_id    = aws_route_table.public_route_table.id
  eip_allocation_id = aws_eip.public_ip.id
}