terraform {
  backend "s3" {
    bucket         = "2560-dev-alpha-s3-backend"
    key            = "eks/put-all-my-eggs-in-one-basket/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-dev-alpha-s3-dynamodb-table"
  }
}
