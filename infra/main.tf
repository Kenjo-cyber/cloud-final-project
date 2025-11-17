provider "aws" {
  region = "eu-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloud-final-vpc"
  }
}


# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "app-sg"
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = "ami-07eb36e50da2fcccd" # Amazon Linux 2 in eu-west-2
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "cloud-final" 
  depends_on = [aws_security_group.app_sg]

  tags = {
    Name = "cloud-final-app"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    service docker start
    docker run -d -p 5000:5000 your-backend-image
    docker run -d -p 80:80 your-frontend-image
  EOF
}

# Output the public IP
output "app_server_ip" {
  value = aws_instance.app_server.private_ip
}