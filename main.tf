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

  depends_on = [
    module.vpc,
    module.s3
  ]
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