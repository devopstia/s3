data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["adl-eks-vpc"]
  }
}

data "aws_subnet" "subnet_01" {
  filter {
    name   = "tag:Name"
    values = ["eks-db-subnet-01"]
  }
}

data "aws_subnet" "subnet_02" {
  filter {
    name   = "tag:Name"
    values = ["eks-db-subnet-02"]
  }
}
