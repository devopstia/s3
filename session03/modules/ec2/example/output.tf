output "ami_id" {
  value = data.aws_ami.ubuntu_20_04.id
}

output "aws_vpc" {
  value = data.aws_vpc.default-vpc.id
}


output "aws_subnet-1" {
  value = data.aws_subnet.default01.id
}

output "aws_subnet-2" {
  value = data.aws_subnet.default02.id
}

output "aws_subnet-3" {
  value = data.aws_subnet.default03.id
}

output "aws_instance_id" {
  value = aws_instance.bastion.id
}
