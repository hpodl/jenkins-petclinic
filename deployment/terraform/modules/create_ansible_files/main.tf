locals {
  # Turns a list of ips into a list of host ips and identity files
  hosts_with_keys = [for ip in var.webserver_ips : "${ip} ansible_ssh_private_key_file=./webserver_key"]

  # Turns former into newline separated string of hosts
  newline_separated_hosts = join("\n", local.hosts_with_keys)

  hosts_file_entries = [for ip in var.webserver_ips : "${ip} ${var.webserver_pubkey}"]
  hosts_file_content = join("\n", local.hosts_file_entries)
}

resource "local_file" "tf_ansible_inventory" {
  filename = "${var.ansible_dir}/inventory"
  content  = <<EOF
# Generated by Terraform
# Ansible inventory containing hosts provided by Terraform
[bastion]
${var.bastion_ip} ansible_ssh_private_key_file=${var.bastion_key_name}

[monitoring]
${var.monitoring_ip} ansible_ssh_private_key_file=${var.monitoring_key_name}

[webservers]
${local.newline_separated_hosts} 

[webservers:vars]
ansible_ssh_common_args="-o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -q ec2-user@${var.bastion_ip} -o IdentityFile=./bastion_key -o Port=22 -W %h:%p \""
EOF
}

resource "local_file" "tf_ansible_vars" {
  filename = "${var.ansible_dir}/tf_variables.yaml"
  content  = <<EOF
# Generated by terraform
# Variables describing infrastructure provided with Terraform
---
load_balancer_ip: ${var.load_balancer_ip}
bastion_ip: ${var.bastion_ip}
db_user: ${var.db_user}
db_password: ${var.db_passwd}
db_url: ${var.db_url}
webserver_ips: [${ join(", ", var.webserver_ips) }]
EOF
}
