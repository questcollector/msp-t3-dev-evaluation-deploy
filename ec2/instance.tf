########################
## keypair
########################

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "pem" {
  filename        = "${path.module}/docker-instance-key.pem"
  content         = tls_private_key.keypair.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "keypair" {
  key_name   = "docker-instance-key"
  public_key = tls_private_key.keypair.public_key_openssh
}

########################
## instance
########################
resource "aws_instance" "bastion" {
  ami             = var.my_ami
  instance_type   = "t2.micro"
  subnet_id       = var.public_subnet_id[0]
  private_ip      = "10.0.1.10"
  security_groups = [aws_security_group.bastion_sg.id]
  key_name        = aws_key_pair.keypair.key_name


  tags = {
    Name = "bastion-server"
  }
}
resource "aws_instance" "docker" {
  ami                  = var.my_ami
  instance_type        = var.instance_type
  subnet_id            = var.private_subnet_id[0]
  private_ip           = "10.0.10.10"
  security_groups      = [aws_security_group.docker_sg.id]
  key_name             = aws_key_pair.keypair.key_name
  iam_instance_profile = aws_iam_instance_profile.docker-sever-profile.name

  user_data = templatefile("${path.module}/userdata.tpl",
  { s3_bucket : var.s3_bucket })

  tags = {
    Name = "evaluation-docker-server"
  }
}