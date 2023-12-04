output "monitoring_ip" {
  value = aws_instance.monitoring_instance.public_ip
}