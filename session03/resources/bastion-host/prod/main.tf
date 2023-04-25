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
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-s3-backend"
    key            = "test-module/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}

module "bastion-host" {
  source        = "../../../modules/bastion-host"
  aws_region    = var.aws_region
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id

  common_tags = var.common_tags
}
