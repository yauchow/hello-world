resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_vpc" "vpc" {
  depends_on = [aws_internet_gateway.internet_gateway]

  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_internet_gateway_attachment" "internet_gateway_attachment" {
  depends_on = [aws_internet_gateway.internet_gateway, aws_vpc.vpc]

  internet_gateway_id = aws_internet_gateway.internet_gateway.id
  vpc_id              = aws_vpc.vpc.id
}

# Main network

resource "aws_route_table" "public_route_table" {
  depends_on = [aws_vpc.vpc]

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_route" "default_public_route" {
  depends_on = [aws_internet_gateway.internet_gateway, aws_route_table.public_route_table]

  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

module "aws_resources_security_group" {
  source = "../aws-resources-security-group"

  environment = var.environment
  vpc         = aws_vpc.vpc.id
  subnets     = [module.subnet_a.id, module.subnet_b.id]
}