variable "vpc_prefix" {
  type    = string
  default = "/2560/adl/vpc"
}

variable "aws_region" {
  type = string
}

variable "common_tags" {
  type = map(any)
  default = {
    "AssetID"       = "2560"
    "AssetName"     = "Insfrastructure"
    "Environment"   = "dev"
    "Project"       = "alpha"
    "CreateBy"      = "Terraform"
    "cloudProvider" = "aws"
  }
}

## VPC
variable "cidr_block" {
  type = string
}

variable "instance_tenancy" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_classiclink" {
  type = bool
}

variable "enable_classiclink_dns_support" {
  type = bool
}

variable "assign_generated_ipv6_cidr_block" {
  type = bool
}

variable "cluster_name" {
  type = string
}

variable "private_subnets_eks_ec2" {
  type = list(any)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

variable "private_subnets_db" {
  type = list(any)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
}

variable "public" {
  type = list(any)
  default = [
    "10.0.5.0/24",
    "10.0.6.0/24",
  ]
}

variable "aws_availability_zones" {
  type = list(any)
  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}

variable "shared" {
  type    = string
  default = "shared"
}
