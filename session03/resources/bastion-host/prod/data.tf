data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"]
  }
}

data "aws_subnet" "subnet_01" {
  filter {
    name   = "tag:Name"
    values = ["default01"]
  }
}
