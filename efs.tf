resource "aws_efs_file_system" "efs" {
  creation_token = "wp-efs"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "mount_target1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.public_subnet1.id
  security_groups = [aws_security_group.efs_security_group.id]
}

resource "aws_efs_mount_target" "mount_target2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.public_subnet2.id
  security_groups = [aws_security_group.efs_security_group.id]
}
