variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for PostgreSQL instance"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for PostgreSQL instance"
}

variable "key_name" {
  type        = string
  description = "SSH Key for PostgreSQL instance"
}
