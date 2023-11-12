locals {
  sql_file = "../ansible/user.sql"
}
resource "aws_db_instance" "petclinic_db" {
  allocated_storage      = 10
  db_name                = "petclinic_db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db_user
  password               = var.db_passwd
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = var.db_subnet_group_name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db_security_groups

  # provisioner "local-exec" {
  #   command = "mariadb --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < ${local.sql_file}"
  # }
}

resource "local_file" "db_create_script" {
  filename = local.sql_file
  content  = <<EOF
CREATE DATABASE IF NOT EXISTS petclinic;

ALTER DATABASE petclinic
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON petclinic.* TO '${var.db_user}'@'${aws_db_instance.petclinic_db.address}' IDENTIFIED BY '${var.db_passwd}';
EOF
}
