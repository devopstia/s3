provider "aws" {
  region = "us-east-1"
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
    key            = "eks/put-all-my-eggs-in-one-basket/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}

locals {
  eks_version             = 1.22
  endpoint_private_access = false
  endpoint_public_access  = true

  common_tags = {
    "AssetID"       = "2560"
    "AssetName"     = "Insfrastructure"
    "Teams"         = "DEL"
    "Environment"   = "dev"
    "Project"       = "alpha"
    "CreateBy"      = "Terraform"
    "cloudProvider" = "aws"
  }
}

module "eks-control-plane" {
  source                  = "../../modules/eks-control-plane"
  eks_version             = local.eks_version
  endpoint_private_access = local.endpoint_private_access
  endpoint_public_access  = local.endpoint_public_access
  common_tags             = local.common_tags
}