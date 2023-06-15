resource "aws_security_group" "docker_sg" {
  name   = "docker_sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker_sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion_sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks_to_access
  }

  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "lb_sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks_to_access
  }

  tags = {
    Name = "lb_sg"
  }
}

###################
## Inbound rules
###################

resource "aws_security_group_rule" "rabbitmq-management" {

  description = "rabbitmq-management - from public subnet cidr"
  type        = "ingress"
  from_port   = 15672
  to_port     = 15672
  protocol    = "TCP"

  cidr_blocks       = var.public_subnet_cidr
  security_group_id = aws_security_group.docker_sg.id
}

resource "aws_security_group_rule" "amqp" {

  description = "amqp - anywhere"
  type        = "ingress"
  from_port   = 5672
  to_port     = 5672
  protocol    = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.docker_sg.id
}

resource "aws_security_group_rule" "api" {

  description = "api - from public subnet cidr"
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "TCP"

  cidr_blocks       = var.public_subnet_cidr
  security_group_id = aws_security_group.docker_sg.id
}

resource "aws_security_group_rule" "ssh" {

  description = "ssh - from bastion"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"

  cidr_blocks       = var.public_subnet_cidr
  security_group_id = aws_security_group.docker_sg.id
}