output "lb_dns" {
  value = aws_lb.evaluation_lb.dns_name
}

output "docker_server_local_ip" {
  value = aws_instance.docker.private_ip
}