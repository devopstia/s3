terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-terraform-state"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-terraform-state-lock"
  }
}
