## Terraform block
terraform {
  required_version = ">= 0.12.30"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = local.aws_region
}


terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-s3-backend"
    key            = "terraform-upgrade/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}

locals {
  aws_region    = "us-east-1"
  instance_type = "t2.micro"
  key_name      = "terraform"

  vpc_id    = "vpc-068852590ea4b093b"
  subnet_id = "subnet-096d45c28d9fb4c14"

  common_tags = {
    "AssetID"       = "2560"
    "AssetName"     = "Insfrastructure"
    "Teams"         = "DEL"
    "Environment"   = "blandine"
    "Project"       = "alpha"
    "CreateBy"      = "Terraform"
    "cloudProvider" = "aws"
  }
}

module "ec2_module" {
  source        = "../../../modules/ec2"
  instance_type = local.instance_type
  key_name      = local.key_name
  vpc_id        = local.vpc_id
  subnet_id     = local.subnet_id

  common_tags = local.common_tags
}
