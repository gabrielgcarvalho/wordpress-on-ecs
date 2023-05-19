resource "aws_vpc" "wp-vpc" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.wp-vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.wp-vpc.id
  cidr_block        = "10.0.0.64/26"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "wp-ig" {
  vpc_id = aws_vpc.wp-vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.wp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp-ig.id
  }

  tags = {
    Name = "wp public route table"
  }
}

resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.wp-vpc.id
  cidr_block        = "10.0.0.128/26"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.wp-vpc.id
  cidr_block        = "10.0.0.192/26"
  availability_zone = "us-east-1b"
}

// Load Balancer

resource "aws_alb" "wp-alb" {
  name            = "wp-alb"
  internal        = false
  security_groups = [aws_security_group.wp-alb-security-group.id]
  subnets = [
    aws_subnet.public_subnet1.id,
    aws_subnet.public_subnet2.id
  ]
}

resource "aws_alb_target_group" "wp-alb-target-group" {

  name        = "wp-alb-tg"
  protocol    = "HTTP"
  target_type = "ip"
  port        = var.container_port
  vpc_id      = aws_vpc.wp-vpc.id



  health_check {
    protocol = "HTTP"
    matcher  = 200
    path     = "/"

    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5

  }
}

resource "aws_lb_listener" "wp-alb-listener" {
  load_balancer_arn = aws_alb.wp-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.wp-alb-target-group.arn
  }
}

resource "aws_db_subnet_group" "wp-db-subnet-groups" {
  name        = "wp-db-subnet-groups"
  description = "WP DB subnet group"
  subnet_ids = [
    aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id
  ]
}

// NAT Gateway

resource "aws_eip" "wp-nat-eip" {
  vpc = true
}

resource "aws_nat_gateway" "wp_nat_gateway" {
  allocation_id = aws_eip.wp-nat-eip.id
  subnet_id     = aws_subnet.public_subnet1.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.wp-vpc.id
}

resource "aws_route_table_association" "private_subnet1_association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet2_association" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.wp_nat_gateway.id
}
