
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

terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-s3-backend"
    key            = "vpc/eks-vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}

locals {
  common_tags = {
    "AssetID"       = "2560"
    "AssetName"     = "Insfrastructure"
    "Environment"   = "dev"
    "Project"       = "alpha"
    "CreateBy"      = "Terraform"
    "cloudProvider" = "aws"
  }
  aws_region              = "us-east-1"
  private_subnets_eks_ec2 = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_db      = ["10.0.3.0/24", "10.0.4.0/24"]
  public                  = ["10.0.5.0/24", "10.0.6.0/24"]
  aws_availability_zones  = ["us-east-1a", "us-east-1b"]

  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block = false

  cluster_name = "2560-dev-alpha"
}

module "vpc-dev" {
  source                           = "../../../modules/vpc/vpc03"
  aws_region                       = local.aws_region
  cidr_block                       = local.cidr_block
  private_subnets_eks_ec2          = local.private_subnets_eks_ec2
  private_subnets_db               = local.private_subnets_db
  public                           = local.public
  aws_availability_zones           = local.aws_availability_zones
  instance_tenancy                 = local.instance_tenancy
  enable_dns_support               = local.enable_dns_support
  enable_dns_hostnames             = local.enable_dns_hostnames
  enable_classiclink               = local.enable_classiclink
  enable_classiclink_dns_support   = local.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = local.assign_generated_ipv6_cidr_block
  cluster_name                     = local.cluster_name
}
