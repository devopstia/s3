resource "aws_security_group" "sg" {
  name   = "postgres-rds-sg"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "postgres-rds-sg-rule" {
  from_port         = 5432
  protocol          = "tcp"
  to_port           = 5432
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_rule" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
