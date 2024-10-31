provider "aws" {
  region = "us-west-2"
}

# Create a new VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terra-vpc"
  }
}

# Create a new subnet within the VPC
resource "aws_subnet" "terra_subnet" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Adjust as needed

  tags = {
    Name = "terra-subnet"
  }
}

# Security group for the instance
resource "aws_security_group" "terra_sg" {
  vpc_id = aws_vpc.terra_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terra-sg"
  }
}

# EC2 instance using the new subnet and security group
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                    = "single-instance"
  instance_type           = "t2.micro"
  key_name                = "user1"
  monitoring              = true
  vpc_security_group_ids  = [aws_security_group.terra_sg.id]
  subnet_id               = aws_subnet.terra_subnet.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
