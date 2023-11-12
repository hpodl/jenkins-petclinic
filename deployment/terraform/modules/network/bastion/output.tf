output "bastion_instance_ip" {
  value = aws_instance.bastion_instance.public_ip
}

output "bastion_pubkey" {
  value = aws_key_pair.bastion_ssh_key.public_key
}
