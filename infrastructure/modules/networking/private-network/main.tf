locals {
  subnets = cidrsubnets(var.base_cidr_block, [for i in var.availability_zones : ceil(length(var.availability_zones) / 2)]...)
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc.id
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

module "private_subnets" {
  source = "../private-subnet"

  count = length(var.availability_zones)

  environment       = var.environment
  vpc               = var.vpc
  availability_zone = var.availability_zones[count.index]
  cidr_block        = local.subnets[count.index]
  route_table_id    = aws_route_table.private.id
}

module "aws_resources_security_group" {
  source = "../aws-resources-security-group"

  region               = var.region
  environment          = var.environment
  vpc                  = var.vpc
  subnets              = module.private_subnets.*.id
  private_route_tables = [aws_route_table.private.id]
}

resource "aws_service_discovery_private_dns_namespace" "private" {
  name        = var.environment
  description = "Private namespace"
  vpc         = var.vpc.id
}