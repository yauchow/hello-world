resource "aws_subnet" "private_subnet" {
  vpc_id = var.vpc.id

  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.environment}-private-${var.availability_zone}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = var.route_table_id
}