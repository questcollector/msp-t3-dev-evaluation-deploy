output "mongodb_password" {
  value     = module.s3.mongodb_password
  sensitive = true
}

output "lb_dns" {
  value = module.ec2.lb_dns
}