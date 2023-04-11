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
  key_name      = "terraform"

  vpc_id    = "vpc-068852590ea4b093b"
  subnet_id = "subnet-05f285a35173783b0"

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

module "bastion-host" {
  source        = "../../../modules/bastion-host"
  aws_region    = local.aws_region
  instance_type = local.instance_type
  key_name      = local.key_name
  vpc_id        = local.vpc_id
  subnet_id     = local.subnet_id

  common_tags = local.common_tags
}




# # Create a Null Resource and Provisioners
# resource "null_resource" "copy_ec2_keys" {
#   depends_on = [module.bastion-host]
#   connection {
#     type        = "ssh"
#     host        = module.bastion-host.public_ip
#     user        = "ubuntu"
#     password    = ""
#     private_key = file("./private-key/terraform.pem")
#   }

#   provisioner "file" {
#     source      = "./bastion-user-data/bastion-host-user-data.sh"
#     destination = "/tmp/bastion-host-user-data.sh"
#   }

#   provisioner "file" {
#     source      = "./private-key/terraform.pem"
#     destination = "/tmp/terraform-key.pem"
#   }

#   provisioner "file" {
#     source      = "./docker/Dockerfile"
#     destination = "/tmp/Dockerfile"
#   }

#   # provisioner "remote-exec" {
#   #   inline = [
#   #     "sudo chmod 600 /tmp/terraform.pem",
#   #     "sudo chmod +x /tmp/bastion-host-user-data.sh",
#   #     "sudo bash /tmp/bastion-host-user-data.sh",
#   #     "cd /tmp",
#   #     "sudo docker build -t devopseasylearning2021/s5tia:microservice .",
#   #     "sudo docker run -d -p 8090:80 --name microservice devopseasylearning2021/s5tia:microservice",
#   #     "sudo docker ps -a",
#   #   ]
#   # }
# }
