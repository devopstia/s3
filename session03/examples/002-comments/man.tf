provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "ec2-instance" {
  ami             = "ami-0557a15b87f6559cf"
  instance_type   = "t2.micro"
  key_name        = "terraform"
  security_groups = [aws_security_group.ec2-instance-sg.name]
  tags = {
    Name = "tia-web"
  }
}


# This block of code is to create a SG === single line comment
resource "aws_security_group" "ec2-instance-sg" {
  name_prefix = "ec2-instance-sg-"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# This block of code is to create a SG === multiple lines comment

# resource "aws_instance" "ec2-instance" {
#   ami             = "ami-0557a15b87f6559cf"
#   instance_type   = "t2.micro"
#   key_name        = "terraform"
#   security_groups = [aws_security_group.ec2-instance-sg.name]
#   tags = {
#     Name = "tia-web"
#   }
# }


# This block of code is to create a SG === multiple lines comment
/*
resource "aws_instance" "ec2-instance" {
  ami             = "ami-0557a15b87f6559cf"
  instance_type   = "t2.micro"
  key_name        = "terraform"
  security_groups = [aws_security_group.ec2-instance-sg.name]
  tags = {
    Name = "tia-web"
  }
}
*/.
