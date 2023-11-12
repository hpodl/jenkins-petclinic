variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_passwd" {
  type      = string
  sensitive = true
}

variable "db_subnet_group_name" {
  type = string
}

variable "db_security_groups" {
  type = list(string)
}