output "mongodb_password" {
  value     = random_password.rand_passwd.result
  sensitive = true
}