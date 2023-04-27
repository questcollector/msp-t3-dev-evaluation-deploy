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

resource "aws_security_group_rule" "rabbitmq-management" {

  description = "rabbitmq-management - global-lounge"
  type        = "ingress"
  from_port   = 15672
  to_port     = 15672
  protocol    = "TCP"

  cidr_blocks       = var.global_lounge_cidr
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

  description = "api - global-lounge"
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "TCP"

  cidr_blocks       = var.global_lounge_cidr
  security_group_id = aws_security_group.docker_sg.id
}

resource "aws_security_group_rule" "mongo" {

  description = "amqp - global-lounge"
  type        = "ingress"
  from_port   = 27017
  to_port     = 27017
  protocol    = "TCP"

  cidr_blocks       = var.global_lounge_cidr
  security_group_id = aws_security_group.docker_sg.id
}