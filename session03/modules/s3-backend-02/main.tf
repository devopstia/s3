resource "aws_s3_bucket" "terraform_state" {
  bucket = format("%s-%s-%s-s3-backend", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
  tags = var.common_tags
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = format("%s-%s-%s-s3-dynamodb-table", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.common_tags
}
