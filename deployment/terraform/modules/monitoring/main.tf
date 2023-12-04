resource "aws_instance" "monitoring_instance" {
  ami                         = "ami-0dbc3d7bc646e8516"
  instance_type               = "t2.medium"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = aws_key_pair.monitoring_ssh_key.key_name

  tags = {
    Name = "monitoring"
  }
}

resource "tls_private_key" "key_pair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "monitoring_ssh_key" {
  key_name   = "monitoring_ssh_key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "monitoring_private_key_file" {
  filename        = "../ansible/monitoring_key"
  content         = tls_private_key.key_pair.private_key_openssh
  file_permission = "0600"
}