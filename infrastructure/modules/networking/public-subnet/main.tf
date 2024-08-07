resource "aws_subnet" "subnet" {
  vpc_id            = var.vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.environment}-public-${var.availability_zone}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "subnet_route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.route_table_id
}

resource "aws_nat_gateway" "nat" {
  count = var.assign_eip ? 1 : 0

  allocation_id = var.eip_allocation_id
  subnet_id     = aws_subnet.subnet.id

  tags = {
    Name        = "${var.environment}-nat"
    Environment = var.environment
  }
}