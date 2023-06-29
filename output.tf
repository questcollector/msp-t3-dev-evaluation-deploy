output "mongodb_password" {
  value     = module.s3.mongodb_password
  sensitive = true
}

output "rabbitmq_password" {
  value     = module.s3.rabbitmq_password
  sensitive = true
}

output "amqp_uri" {
  value = aws_route53_record.amqp.name
}

output "api_uri" {
  value = aws_route53_record.api.name
}

output "rabbitmq_managment_uri" {
  value = aws_route53_record.rabbitmq_management.name
}

output "lambda_url" {
  value = module.lambda.function_url
}

output "bastion_server_public_ip" {
  value = module.ec2.bastion_server_public_ip
}