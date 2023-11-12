variable "region" {
  description = "region of the main vpc and all the other resources"
  type        = string
  default     = "us-east-1"
}

variable "private_key_path" {
  description = "directory in which the newly generated key pair will be saved"
  type        = string
  default     = "./"
  sensitive   = true
}

variable "db_user" {
  description = "database username"
  type        = string
  sensitive   = true
}

variable "db_passwd" {
  description = "database password"
  type        = string
  sensitive   = true
}
