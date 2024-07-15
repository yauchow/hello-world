// Provisions a Security group that will give task definitions access to
// AWS resources via a VPC Endpoint

resource "aws_security_group" "aws_resources_security_group" {
  name        = "${var.environment}-AwsResourceSecurityGroup"
  description = "Gives task definitions the required network access to connect to aws resources such as ECR"
  vpc_id      = var.vpc

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
  service_name        = "com.amazonaws.ap-southeast-2.ecr.api"
  vpc_id              = var.vpc
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
  service_name        = "com.amazonaws.ap-southeast-2.ecr.dkr"
  vpc_id              = var.vpc
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