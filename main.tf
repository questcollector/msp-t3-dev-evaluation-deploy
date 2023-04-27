module "vpc" {
  source = "./vpc"
}

module "s3" {
  source      = "./s3"
  slack_token = var.slack_token
}

module "ec2" {
  source             = "./ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_id  = module.vpc.private_subnet_id
  public_subnet_id   = module.vpc.public_subnet_id
  my_ami             = var.my_ami
  instance_type      = var.instance_type
  global_lounge_cidr = var.global_lounge_cidr

  depends_on = [
    module.vpc,
    module.s3
  ]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "msp-t3-dev-evaluation"

  tags = {
    Environment = "production"
  }
}