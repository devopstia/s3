locals {
  control_plane_name = format("%s-%s-%s", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
}


resource "null_resource" "cluster-auth-apply" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${local.control_plane_name} --region ${var.aws_region} --alias ${local.control_plane_name}"
  }
}
