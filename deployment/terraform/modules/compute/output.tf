output "webserver_pub_ips" {
  value = data.aws_instances.running_webservers.public_ips
}

output "webserver_priv_ips" {
  value = data.aws_instances.running_webservers.private_ips
}

output "webserver_pubkey" {
  value = aws_key_pair.webserver_ssh_key.public_key
}
