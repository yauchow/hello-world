// Provisions a Security group that will give task definitions access to
// AWS resources via a VPC Endpoint

resource "aws_security_group" "aws_resources_security_group" {
  name        = "${var.environment}-AwsResourceSecurityGroup"
  description = "Gives task definitions the required network access to connect to aws resources such as ECR"
  vpc_id      = var.vpc.id

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
    Name        = "${var.environment}-AwsResourceSecurityGroup"
    Environment = var.environment
  }
}

// Access to the ECR Api
resource "aws_vpc_endpoint" "ecr_api_interface_endpoint" {
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_id              = var.vpc.id
  private_dns_enabled = true

  subnet_ids = var.subnets

  security_group_ids = [
    aws_security_group.aws_resources_security_group.id
  ]

  tags = {
    Name        = "${var.environment}-ecr-api-endpoint"
    Environment = var.environment
  }
}

// Access to ECR docker endpoint
resource "aws_vpc_endpoint" "ecr_docker_interface_endpoint" {
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_id              = var.vpc.id
  private_dns_enabled = true

  subnet_ids = var.subnets

  security_group_ids = [
    aws_security_group.aws_resources_security_group.id
  ]

  tags = {
    Name        = "${var.environment}-ecr-dkr-endpoint"
    Environment = var.environment
  }
}


resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_id            = var.vpc.id

  route_table_ids = var.private_route_tables

  # policy = jsonencode(

  # )

  tags = {
    Name        = "${var.environment}-s3"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "logs_endpoint" {
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_id              = var.vpc.id
  private_dns_enabled = true

  subnet_ids = var.subnets

  security_group_ids = [
    aws_security_group.aws_resources_security_group.id
  ]

  tags = {
    Name        = "${var.environment}-logs"
    Environment = var.environment
  }
}