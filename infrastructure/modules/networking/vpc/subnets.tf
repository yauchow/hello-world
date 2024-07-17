module "subnet_a" {
  depends_on = [aws_vpc.vpc, aws_route_table.public_route_table]
  source     = "../public-subnet"

  name              = "${var.environment}-subnet-a"
  environment       = var.environment
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  route_table_id    = aws_route_table.public_route_table.id
}

module "subnet_b" {
  depends_on = [aws_vpc.vpc, aws_route_table.public_route_table]
  source     = "../public-subnet"

  name              = "${var.environment}-subnet-b"
  environment       = var.environment
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b"
  route_table_id    = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.0.201.0/24"

  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
  }
}