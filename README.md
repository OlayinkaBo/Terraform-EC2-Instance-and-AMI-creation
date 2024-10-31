# Terraform-EC2-Instance-and-AMI-creation

## Purpose

To learn how to use Terraform to automate the creation of EC2 instance on AWS and then create an Amazon Machine Image (AMI) from that instance.

## Objectives 

1. Terraform Installation

   - Install terraform on the server

2. Terraform Configuration

   - Learn to write basic Terraform configuration files.

3. EC2 Instance Creation

   - Use Terraform to create EC2 instance on AWS.

4. AMI Creation

   - Automate the creation of an AMI from the created EC2 instance.

## Project Tasks

# Task 1: Terraform installation and configuration for EC2 instance

1. Install terraform on AWS EC2 server.
  
![alt text](<Images/terraform server.PNG>)

![alt text](<Images/terraform server2.PNG>)


2. Install AWS Cli 

 - Install AWScli

 `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`

 `unzip awscliv2.zip`

 `sudo ./aws/install`

 `aws --version`

![alt text](<Images/AWS Cli.PNG>)

3. Configure AWS 

`AWS Configure`

![alt text](<Images/AWS Configure.PNG>)



2. Create a new directory for your Terraform project (e.g. 'terraform-ec2-ami')

![alt text](<Images/mkdir terraform.PNG>)

3. Inside the project directory, create a Terraform configuration file (e.g. main.tf)

![alt text](<Images/terraform main.PNG>)

4. Write Terraform code to create an EC2 instance. Specify instance type, key pair, security group etc.

```
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
```
### Explanation of the Configuration

- VPC Creation: The aws_vpc resource defines a new VPC with a 10.0.0.0/16 CIDR block.
- Subnet Creation: The aws_subnet resource creates a subnet in the new VPC using part of its IP range.
- Security Group: The aws_security_group resource sets up SSH access.
- EC2 Instance: The module "ec2_instance" references the newly created subnet ID and security group, ensuring that they exist before the EC2 instance is provisioned.

This configuration will ensure the subnet is created dynamically as part of the infrastructure, and then the EC2 instance will use this new subnet ID without needing prior knowledge of it.

![alt text](<Images/terraform code.PNG>)

5. Initialize the terraform project using the command: `terraform init`.

![alt text](<Images/terraform init.PNG>)

6. Validate the terraform configuration using the command `terraform validate`.

![alt text](<Images/terraform validate.PNG>)

7. Check and review terraform plan using the command: `terraform plan`.

![alt text](<Images/terraform plan.PNG>)
![alt text](<Images/terraform plan2.PNG>)

8. Apply the terraform configuration to create the  EC2 instance using the command: `terraform apply`.

![alt text](<Images/terraform apply.PNG>)

![alt text](<Images/terraform apply2.PNG>)

![alt text](<Images/EC2 by terraform.png>)

## Task 2: AMI Creation

1. Extend your terraform configuration to include the creation of an AMI.
2. Use provisioners in Terraform to execute commands on the EC2 instance after it is created. Install necessary packages or perform any setup required.
3. Configure Terraform to create an AMI from the provisioned EC2 instance.
4. Apply the update Terraform configuration to create the AMI using the command `terraform apply`.

## Instructions:

1. Create a new Terraform configuration file (`ami.tf`)

![alt text](<Images/Terraform ami.PNG>)

2. Write Terraform code to crrate the ami from the EC2 instance created.

```
data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "terra_instance" {
  ami           = data.aws_ami.latest_ami.id
  instance_type = "t2.micro"
  key_name      = "user1"
  # Additional configurations...
}
```
**Note**: Using the data "aws_ami" block will help avoid hardcoding AMI IDs and ensure you always use the latest compatible AMI. 

![alt text](<Images/Terraform ami2.PNG>)

3. On the terminal, run `terraform validate` to confirm the code is valid then `tarraform plan` to see the plan and finally 'terraform apply` to implement.

![alt text](<Images/terraform apply ami.PNG>)![alt text](<Images/terraform apply ami2.PNG>)

![alt text](Images/Success.PNG)