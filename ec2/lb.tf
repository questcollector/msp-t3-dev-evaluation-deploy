resource "aws_lb" "amqp_lb" {
  name               = "amqp-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb" "api_lb" {
  name               = "api-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_id

  enable_deletion_protection = false
  security_groups            = [aws_security_group.lb_sg.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb" "management_lb" {
  name               = "management-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_id

  enable_deletion_protection = false
  security_groups            = [aws_security_group.lb_sg.id]

  tags = {
    Environment = "production"
  }
}

###################
## target groups
###################

resource "aws_lb_target_group" "amqp" {
  name     = "amqp-tg"
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
  name     = "management-tg"
  port     = 15672
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "rabbitmq_management" {
  target_group_arn = aws_lb_target_group.rabbitmq_management.arn
  target_id        = aws_instance.docker.id
  port             = 15672
}

resource "aws_lb_target_group" "api" {
  name     = "api-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "api" {
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = aws_instance.docker.id
  port             = 8080
}


###################
## listeners
###################


resource "aws_lb_listener" "amqp" {
  load_balancer_arn = aws_lb.amqp_lb.arn
  port              = "5672"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.amqp.arn
  }
}

resource "aws_lb_listener" "rabbitmq-management" {
  load_balancer_arn = aws_lb.management_lb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rabbitmq_management.arn
  }
}


resource "aws_lb_listener" "api-https" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_listener" "api-http" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
