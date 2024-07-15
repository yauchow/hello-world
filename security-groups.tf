resource "aws_security_group" "environment_http_security_group" {
  depends_on = [aws_vpc.vpc]

  name        = "${local.environment}-http-security-group"
  description = "Http access on port 80 for the environment"

  vpc_id = aws_vpc.vpc.id


  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}