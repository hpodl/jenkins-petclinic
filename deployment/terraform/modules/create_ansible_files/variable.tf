variable "ansible_dir" {
  type    = string
  default = "../ansible"
}

variable "webserver_ips" {
  type = list(string)
}
variable "bastion_ip" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "webserver_pubkey" {
  type = string
}

variable "bastion_key_name" {
  type    = string
  default = "bastion_key"
}

variable "bastion_pubkey" {
  type    = string
  default = "bastion_key"
}

variable "db_user" {
  type = string
}

variable "db_passwd" {
  type = string
}

variable "db_url" {
  type = string
}
