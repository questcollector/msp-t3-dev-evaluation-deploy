output "amqp_lb" {
  value = aws_lb.amqp_lb
}

output "api_lb" {
  value = aws_lb.api_lb
}

output "rabbitmq_management_lb" {
  value = aws_lb.management_lb
}

output "docker_server_local_ip" {
  value = aws_instance.docker.private_ip
}

output "bastion_server_public_ip" {
  value = aws_instance.bastion.public_ip
}