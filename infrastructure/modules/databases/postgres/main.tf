resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  db_name = "${var.environment}-${var.name}"
}

resource "aws_security_group" "security_group" {
  vpc_id = var.vpc.id
  name   = "${local.db_name}-security-group"
  ingress {
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.db_name}-subnet-group"
  subnet_ids = var.vpc.private_subnets
}

resource "aws_db_instance" "postgres" {
  engine         = "postgres"
  engine_version = "16.3"
  db_name                = replace(local.db_name, "-", "")
  identifier             = local.db_name
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username               = var.username
  password               = random_password.password.result
  vpc_security_group_ids = [aws_security_group.security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot    = true

  tags = {
    Name        = local.db_name,
    Environment = var.environment
  }
}