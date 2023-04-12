## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #   version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-s3-backend"
    key            = "ec2-aws/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = "ami-07bd1fad0c7a958db" # Amazon Linux 2 AMI
  instance_type          = "t2.medium"
  subnet_id              = "subnet-096d45c28d9fb4c14"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = "terraform"

  tags = {
    "Name"          = format("%s-%s-%s-bastion-host", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
    "AssetID"       = "2560"
    "AssetName"     = "Insfrastructure"
    "Teams"         = "DEL"
    "Environment"   = "blandine"
    "Project"       = "alpha"
    "CreateBy"      = "Terraform"
    "cloudProvider" = "aws"
  }
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
