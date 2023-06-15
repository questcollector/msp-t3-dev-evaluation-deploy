output "lb_dns" {
  value = aws_lb.amqp_lb.dns_name
}

output "docker_server_local_ip" {
  value = aws_instance.docker.private_ip
}

output "bastion_server_public_ip" {
  value = aws_instance.bastion.public_ip
}