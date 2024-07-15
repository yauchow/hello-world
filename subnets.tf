resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.0.201.0/24"

  tags = {
    Name = "Defintiv-${terraform.workspace}-private-subnet"
  }
}

resource "aws_subnet" "subnet_a" {
  depends_on = [aws_vpc.vpc]

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Defintiv-${terraform.workspace}-subnet-a"
    Application = "Defintitiv-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "subnet_a_route_table_association" {
  depends_on = [aws_subnet.subnet_a, aws_route_table.public_route_table]

  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "subnet_b" {
  depends_on = [aws_vpc.vpc]

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Defintiv-${terraform.workspace}-subnet-b"
    Application = "Defintitiv-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "subnet_b_route_table_association" {
  depends_on = [aws_subnet.subnet_b, aws_route_table.public_route_table]

  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}