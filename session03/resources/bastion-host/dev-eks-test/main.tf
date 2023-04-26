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
  aws_region    = "us-east-1"
  instance_type = "t2.micro"
  key_name      = "jenkins-key"
  ami           = "ami-0428feff696311306"
  vpc_id        = "vpc-02ca06ad2c2aa4920"
  subnet_id     = "subnet-042cfbe9a269ecd4d"

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

module "ec2_module" {
  source        = "../../../modules/ec2-packer"
  ami           = local.ami
  instance_type = local.instance_type
  key_name      = local.key_name
  vpc_id        = local.vpc_id
  subnet_id     = local.subnet_id

  common_tags = local.common_tags
}
