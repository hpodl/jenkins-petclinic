output "monitoring_ip" {
  value = aws_instance.monitoring_instance.public_ip
}
output "monitoring_subnet_cidr_block" {
  value = var.subnet_id.cidr_block
}