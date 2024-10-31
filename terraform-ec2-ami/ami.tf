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


