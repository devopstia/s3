resource "aws_iam_role" "nodes_general" {
  name = "eks-node-group-general"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

locals {
  control_plane_name = "2560-dev-alpha"
}
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.nodes_general.name
}

resource "aws_eks_node_group" "nodes_general" {
  cluster_name = data.aws_eks_cluster.example.name
  node_group_name = "nodes-general"
  node_role_arn = aws_iam_role.nodes_general.arn

  subnet_ids = [
      data.aws_subnet.private_subnet1.id,
      data.aws_subnet.private_subnet2.id
    ]

  scaling_config {
    desired_size = 1
    max_size = 5
    min_size = 1
  }
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
  force_update_version = false
  instance_types = ["t2.micro"]

  labels = {
    role = "nodes-general"
  }

  version = "1.22"

  remote_access {
    ec2_ssh_key = "jenkins-key"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  tags = {
    Name                                                    = "Apha Blue Node Group"
    "k8s.io/cluster-autoscaler/${local.control_plane_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                     = "true"
  }
}
