resource "aws_lb" "evaluation_lb" {
  name               = "evaluation-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

###################
## target groups
###################

resource "aws_lb_target_group" "amqp" {
  name     = "evaluation-lb-tg-amqp"
  port     = 5672
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "amqp" {
  target_group_arn = aws_lb_target_group.amqp.arn
  target_id        = aws_instance.docker.id
  port             = 5672
}

resource "aws_lb_target_group" "rabbitmq_management" {
  name     = "evaluation-lb-tg-management"
  port     = 15672
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "rabbitmq_management" {
  target_group_arn = aws_lb_target_group.rabbitmq_management.arn
  target_id        = aws_instance.docker.id
  port             = 15672
}

resource "aws_lb_target_group" "api" {
  name     = "evaluation-lb-tg-api"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "api" {
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = aws_instance.docker.id
  port             = 8080
}

resource "aws_lb_target_group" "mongodb" {
  name     = "evaluation-lb-tg-mongodb"
  port     = 27017
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "mongodb" {
  target_group_arn = aws_lb_target_group.mongodb.arn
  target_id        = aws_instance.docker.id
  port             = 27017
}


###################
## listeners
###################


resource "aws_lb_listener" "amqp" {
  load_balancer_arn = aws_lb.evaluation_lb.arn
  port              = "5672"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.amqp.arn
  }
}

resource "aws_lb_listener" "rabbitmq-management" {
  load_balancer_arn = aws_lb.evaluation_lb.arn
  port              = "15672"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rabbitmq_management.arn
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.evaluation_lb.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_listener" "mongodb" {
  load_balancer_arn = aws_lb.evaluation_lb.arn
  port              = "27017"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mongodb.arn
  }
}