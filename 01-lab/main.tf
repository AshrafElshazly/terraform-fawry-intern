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


resource "aws_instance" "my-ec2" {
  ami           = "ami-0418306302097dbff"
  instance_type = "t2.micro"
}
