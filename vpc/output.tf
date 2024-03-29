output "vpc_id" {
  value = aws_vpc.terra.id
}

output "private_subnet_id" {
  value = aws_subnet.private.*.id
}

output "public_subnet_id" {
  value = aws_subnet.public.*.id
}

output "public_subnet_cidr" {
  value = aws_subnet.public.*.cidr_block
}