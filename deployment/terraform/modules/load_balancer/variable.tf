variable "lb_eip_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}