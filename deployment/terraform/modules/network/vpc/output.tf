output "subnet_id" {
  value = aws_subnet.webserver_subnet.id
}

output "backup_subnet_id" {
  value = aws_subnet.db_backup_subnet.id
}

output "vpc_id" {
  value = aws_vpc.main_cloud.id
}

output "gateway_id" {
  value = aws_internet_gateway.gateway_main.id
}

output "sg_allow_http_id" {
  value = aws_security_group.sg_allow_http.id
}

output "sg_allow_ssh_id" {
  value = aws_security_group.sg_allow_ssh.id
}

output "sg_egress_all_id" {
  value = aws_security_group.sg_allow_all_egress.id
}

output "sg_database_id" {
  value = aws_security_group.sg_database.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.petclinic_db_subnet.name
}

output "sg_all_within_subnet_id" {
  value = aws_security_group.sg_all_within_subnet.id
}

output "lb_eip_id" {
  value = aws_eip.lb_eip.id
}