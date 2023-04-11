## Terraform block
terraform {
  required_version = ">= 1.0.0"
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

locals {
  aws_region    = "us-west-2"
  instance_type = "t2.micro"
  key_name      = "test"

  vpc_id    = "vpc-19080661"
  subnet_id = "subnet-cfd133e5"

  common_tags = {
    "AssetID"       = "2560"
    "AssetName"     = "Insfrastructure"
    "Teams"         = "DEL"
    "Environment"   = "prod"
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
  common_tags   = local.common_tags
}
