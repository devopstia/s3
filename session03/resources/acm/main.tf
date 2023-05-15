
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "> 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-s3-backend"
    key            = "acm-alpha/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}

module "acm" {
  source                    = "../../modules/acm"
  aws_region                = var.aws_region
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  common_tags               = var.common_tags
}
