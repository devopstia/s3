data "aws_vpc" "default-vpc" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"]
  }
}

data "aws_subnet" "default01" {
  filter {
    name   = "tag:Name"
    values = ["default01"]
  }
}

data "aws_subnet" "default02" {
  filter {
    name   = "tag:Name"
    values = ["default02"]
  }
}

data "aws_subnet" "default03" {
  filter {
    name   = "tag:Name"
    values = ["default03"]
  }
}
