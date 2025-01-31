variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for Bastion"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for Bastion"
}

variable "key_name" {
  type        = string
  description = "SSH Key Name for Bastion Host"
}
