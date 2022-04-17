terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

}

#Creating VPC for HDFC back
resource "aws_vpc" "HDFC-VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "HDFC_VPC"
  }
}

#Creating Internet Gateway for HDFC bank and attach to HDFC-VPC
resource "aws_internet_gateway" "HDFC_IGW" {
  vpc_id = aws_vpc.HDFC-VPC.id
  tags = {
    Name = "HDFC_IGW"
  }
}

#Creating Public Subnet for HDFC bank
resource "aws_subnet" "HDFC_PUB_1A" {
  vpc_id                  = aws_vpc.HDFC-VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "HDFC_PUB_1A"
  }
}

#Creating Private Subnet for HDFC bank
resource "aws_subnet" "HDFC_PRIV_1B" {
  vpc_id            = aws_vpc.HDFC-VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "HDFC_PRIV_1B"
  }
}

#Creating Route table for Public Subnet
resource "aws_route_table" "HDFC_PUB_RT" {
  vpc_id = aws_vpc.HDFC-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.HDFC_IGW.id
  }
  tags = {
    Name = "HDFC_PUB_RT"
  }
}

#Route table Association with Public Subnet
resource "aws_route_table_association" "A" {
  subnet_id      = aws_subnet.HDFC_PUB_1A.id
  route_table_id = aws_route_table.HDFC_PUB_RT.id
}

output "HDFC-VPC" {
  value = aws_vpc.HDFC-VPC.id
}

output "HDFC_PUB_1A" {
  value = aws_subnet.HDFC_PUB_1A.id
}

#Creating security group sg
resource "aws_security_group" "tf_ssh_access" {
  name   = "tf_ssh_access"
  vpc_id = aws_vpc.HDFC-VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create AWS EC2 instance
resource "aws_instance" "linux-server" {
  ami                         = "ami-0d2986f2e8c0f7d01" #Amazon Linux2 kernel5
  subnet_id                   = aws_subnet.HDFC_PUB_1A.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.tf_ssh_access.id]
  key_name                    = "AWSLinuxKey"
  tags = {
    Name = "linux-server"
  }
}


output "linux-server" {
  value = aws_instance.linux-server.public_ip
}




