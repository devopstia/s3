# EC2 Instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu_20_04.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = data.aws_subnet.default01.id
  tags = merge(var.common_tags, {
    Name = format("%s-%s-%s-bastion-host", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
    },
  )
}

# Create Elastic IP for Bastion Host
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  vpc      = true
  tags = merge(var.common_tags, {
    Name = format("%s-%s-%s-bastion-host-eip", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
    },
  )
}

# Create a Null Resource and Provisioners
resource "null_resource" "copy_ec2_keys" {
  depends_on = [aws_instance.bastion]
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ubuntu"
    password    = ""
    private_key = file("private-key/terraform.pem")
  }

  provisioner "file" {
    source      = "./bastion-user-data/bastion-host-user-data.sh"
    destination = "/tmp/bastion-host-user-data.sh"
  }

  provisioner "file" {
    source      = "./private-key/terraform.pem"
    destination = "/tmp/terraform-key.pem"
  }

  provisioner "file" {
    source      = "docker/Dockerfile"
    destination = "/tmp/Dockerfile"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 /tmp/terraform.pem",
      "sudo chmod +x /tmp/bastion-host-user-data.sh",
      "sudo bash /tmp/bastion-host-user-data.sh",
      "cd /tmp",
      "sudo docker build -t devopseasylearning2021/s5tia:microservice .",
      "sudo docker run -d -p 8090:80 --name microservice devopseasylearning2021/s5tia:microservice",
      "sudo docker ps -a",
    ]
  }
}
