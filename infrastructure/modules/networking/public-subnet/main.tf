
resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_route_table_association" "subnet_route_table_association" {
  depends_on = [aws_subnet.subnet]

  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.route_table_id
}