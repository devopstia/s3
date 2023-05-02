common_tags = {
  "AssetID"       = "2560"
  "AssetName"     = "Insfrastructure"
  "Environment"   = "dev"
  "Project"       = "alpha"
  "CreateBy"      = "Terraform"
  "cloudProvider" = "aws"
}
aws_region = "us-east-1"

cidr_block                       = "10.0.0.0/16"
instance_tenancy                 = "default"
enable_dns_support               = true
enable_dns_hostnames             = true
enable_classiclink               = false
enable_classiclink_dns_support   = false
assign_generated_ipv6_cidr_block = false

cluster_name = "demo-cluster"


