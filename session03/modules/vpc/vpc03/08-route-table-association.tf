resource "aws_route_table_association" "public_01" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_02" {
  subnet_id      = aws_subnet.public-subnet-02.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_01" {
  subnet_id      = aws_subnet.private_subnets_eks_ec2_01.id
  route_table_id = aws_route_table.eks-private-01-route.id
}

resource "aws_route_table_association" "private_02" {
  subnet_id      = aws_subnet.private_subnets_eks_ec2_02.id
  route_table_id = aws_route_table.eks-private-02-route.id
}


resource "aws_route_table_association" "private_03" {
  subnet_id      = aws_subnet.private-subnet-db-01.id
  route_table_id = aws_route_table.db-private-01-route.id
}

resource "aws_route_table_association" "private_04" {
  subnet_id      = aws_subnet.private-subnet-db-02.id
  route_table_id = aws_route_table.db-private-02-route.id
}

