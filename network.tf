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
