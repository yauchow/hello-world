resource "aws_security_group" "aws_resources_security_group" {
  depends_on  = [aws_vpc.vpc]
  name        = "${local.environment}-AwsResourceSecurityGroup"
  description = "Gives task definitions the required network access to connect to aws resources such as ECR"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = local.environment
    Environment = local.environment
  }
}

resource "aws_vpc_endpoint" "ecr_api_interface_endpoint" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway,
    aws_subnet.subnet_a,
    aws_subnet.subnet_b
  ]

  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.ap-southeast-2.ecr.api"
  vpc_id              = aws_vpc.vpc.id
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.aws_resources_security_group.id
  ]

  tags = {
    Name        = "${local.environment}-ecr-api-endpoint"
    Environment = local.environment
  }
}

resource "aws_vpc_endpoint" "ecr_docker_interface_endpoint" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway,
    aws_subnet.subnet_a,
    aws_subnet.subnet_b
  ]

  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.ap-southeast-2.ecr.dkr"
  vpc_id              = aws_vpc.vpc.id
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.aws_resources_security_group.id
  ]

  tags = {
    Name        = "${local.environment}-ecr-dkr-endpoint"
    Environment = local.environment
  }
}