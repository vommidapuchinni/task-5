provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_security_group" "medusa_sg" {
  name_prefix = "medusa_sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9001
    to_port     = 9001
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

resource "aws_instance" "medusa_instance" {
  ami           = "ami-0e86e20dae9224db8" # Replace with the latest Ubuntu AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "medusaterraform" # Replace with your SSH key name
  vpc_security_group_ids = [
    aws_security_group.medusa_sg.id,
  ]
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "MedusaInstance"
  }
}

output "instance_ip" {
  value = aws_instance.medusa_instance.public_ip
}

