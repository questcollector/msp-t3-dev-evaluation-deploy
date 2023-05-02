output "mongodb_password" {
  value     = random_password.mongodb_passwd.result
  sensitive = true
}

output "rabbitmq_password" {
  value     = random_password.rabbitmq_passwd.result
  sensitive = true
}

output "s3_bucket" {
  value = aws_s3_bucket.docker_server_data.id
}