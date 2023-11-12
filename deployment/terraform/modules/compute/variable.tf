variable "vpc_id" {
  description = "id of vpc in which compute resources will reside"
  type        = string
}

variable "subnet_id" {
  description = "id of subnet in which compute resources will reside"
  type        = string
}

variable "security_group_ids" {
  description = "list of security group ids to be applied to the instance"
  type        = list(string)
}

variable "private_key_path" {
  description = ""
  type        = string
}

variable "target_group_arns" {
  type = list(string)
}
