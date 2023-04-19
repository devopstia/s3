resource "aws_db_instance" "alpha-db" {
  instance_class             = "db.t2.small" #1cpu and 2G of ram
  engine                     = "postgres"
  identifier                 = "s3-postgres"
  engine_version             = "10.20"
  port                       = 5432
  multi_az                   = false
  publicly_accessible        = false
  deletion_protection        = false
  auto_minor_version_upgrade = false
  storage_encrypted          = true
  storage_type               = "gp2"
  allocated_storage          = 20
  max_allocated_storage      = 100
  name                       = "s3"
  username                   = data.aws_secretsmanager_secret_version.rds_username.secret_string
  password                   = data.aws_secretsmanager_secret_version.rds_password.secret_string
  apply_immediately          = "true"
  backup_retention_period    = 0
  skip_final_snapshot        = true
  # backup_window           = "09:46-10:16"
  db_subnet_group_name   = aws_db_subnet_group.alpha-postgres-db-subnet.name
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  tags = {
    Name = "postgres-alpha-cicd-db"
  }
}


resource "aws_db_subnet_group" "alpha-postgres-db-subnet" {
  name = "alpha-postgres-db-subnet"
  subnet_ids = [
    "${data.aws_subnet.subnet_01.id}",
    "${data.aws_subnet.subnet_02.id}",
  ]
}


resource "aws_route53_record" "example" {
  zone_id = "Z09063052B43KCQ7FSGHY"
  name    = "s3db"
  type    = "CNAME"
  ttl     = "300"
  #   records = [aws_db_instance.alpha-db.endpoint]
  records = [split(":", aws_db_instance.alpha-db.endpoint)[0]]

}


# locals {
#   endpoint_without_port = split(":", "s3-postgres.cv3uwkomseya.us-east-1.rds.amazonaws.com:5432")[0]
# }

# output "endpoint_without_port" {
#   value = local.endpoint_without_port
# }


variable "aws-secret-string" {
  type = set(string)
  default = [
    "db-password",
    "db-username"
  ]
}

resource "aws_secretsmanager_secret" "example" {
  for_each = var.aws-secret-string
  name     = each.key
  tags = {
    "Terraform" = "true"
    "Project"   = "MAM"
  }
}



# Get secret information for RDS password
data "aws_secretsmanager_secret" "rds_password" {
  name = "db-password"
}
data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}

# Get secret information for RDS username
data "aws_secretsmanager_secret" "rds_username" {
  name = "db-username"
}
data "aws_secretsmanager_secret_version" "rds_username" {
  secret_id = data.aws_secretsmanager_secret.rds_username.id
}


/*
// CREATE A DATABASE WITH USERNAME AND PASSWORD
password = data.aws_secretsmanager_secret_version.rds_password.secret_string
username = data.aws_secretsmanager_secret_version.rds_username.secret_string
*/
