resource "aws_db_parameter_group" "wp-db-parameter-group" {
  name        = "wp-db-parameter-group"
  family      = "mariadb10.6"
  description = "WP DB parameter group"
}

resource "aws_db_instance" "wp-db" {
  identifier              = "wp-db"
  engine                  = "mariadb"
  engine_version          = "10.6.12"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "wordpress"
  username                = var.database.username
  password                = var.database.password
  db_subnet_group_name    = aws_db_subnet_group.wp-db-subnet-groups.name
  vpc_security_group_ids  = [aws_security_group.wp-rds-security-group.id]
  parameter_group_name    = aws_db_parameter_group.wp-db-parameter-group.name
  backup_retention_period = 3
  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  apply_immediately       = true

  depends_on = [
    aws_db_subnet_group.wp-db-subnet-groups,
    aws_security_group.wp-rds-security-group,
    aws_db_parameter_group.wp-db-parameter-group
  ]
}
