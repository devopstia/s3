resource "aws_instance" "example" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = var.instance_type[0]
  key_name      = var.key_name

  tags = merge(var.common_tags, {
    Name = format("%s-%s-%s-bastion-host", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
    "DEL" = "Learning"
    },
  )
}




