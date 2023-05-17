module "network" {
  source = "./modules/network"
}

resource "aws_efs_file_system" "efs" {
  creation_token = "wp-efs"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_security_group" "efs_security_group" {
  name        = "efs-security-group"
  description = "Security group for EFS"

  vpc_id = modules.network.wp-vpc.id

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

resource "aws_efs_mount_target" "mount_target1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = modules.network.public_subnet1.id
  security_groups = [aws_security_group.efs_security_group.id]
}

resource "aws_efs_mount_target" "mount_target2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = modules.network.public_subnet2.id
  security_groups = [aws_security_group.efs_security_group.id]
}
