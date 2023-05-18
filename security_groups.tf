
resource "aws_security_group" "efs_security_group" {
  name        = "efs-security-group"
  description = "Security group for EFS"

  vpc_id = aws_vpc.wp-vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/24"]
  }
}
