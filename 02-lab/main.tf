terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_instance" "server1" {
  ami           = "ami-0418306302097dbff"
  instance_type = "t2.micro"
  key_name      = "labs_key"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "server1"
  }
  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

resource "aws_instance" "server2" {
  ami           = "ami-0418306302097dbff"
  instance_type = "t2.micro"
  key_name      = "labs_key"
  subnet_id              = aws_subnet.public_subnet.id
  tags = {
    Name = "server2"
  }
  depends_on = [aws_instance.server1]
}
