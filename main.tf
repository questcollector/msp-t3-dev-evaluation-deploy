module "vpc" {
  source = "./vpc"
}

module "s3" {
  source      = "./s3"
  slack_token = var.slack_token
}

module "ec2" {
  source                = "./ec2"
  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = module.vpc.private_subnet_id
  public_subnet_id      = module.vpc.public_subnet_id
  public_subnet_cidr    = module.vpc.public_subnet_cidr
  my_ami                = var.my_ami
  instance_type         = var.instance_type
  cidr_blocks_to_access = var.cidr_blocks_to_access
  s3_bucket             = module.s3.s3_bucket
  acm_arn               = var.acm_arn

  depends_on = [
    module.vpc,
    module.s3
  ]
}

data "aws_route53_zone" "domain" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "amqp" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "amqp.${var.route53_zone_name}"
  type    = "A"

  alias {
    name                   = module.ec2.amqp_lb.dns_name
    zone_id                = module.ec2.amqp_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "api.${var.route53_zone_name}"
  type    = "A"

  alias {
    name                   = module.ec2.api_lb.dns_name
    zone_id                = module.ec2.api_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rabbitmq_management" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "rabbitmq-management.${var.route53_zone_name}"
  type    = "A"

  alias {
    name                   = module.ec2.rabbitmq_management_lb.dns_name
    zone_id                = module.ec2.rabbitmq_management_lb.zone_id
    evaluate_target_health = true
  }
}

module "lambda" {
  depends_on = [
    module.ec2
  ]
  source                 = "./lambda"
  vpc_id                 = module.vpc.vpc_id
  private_subnet_id      = module.vpc.private_subnet_id
  public_subnet_id       = module.vpc.public_subnet_id
  docker_server_local_ip = module.ec2.docker_server_local_ip
  start_date             = var.start_date
  end_date               = var.end_date
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "msp-t3-dev-evaluation"

  tags = {
    Environment = "production"
  }
}