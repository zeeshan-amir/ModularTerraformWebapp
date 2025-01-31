variable "vpc_id" {
  type        = string
  description = "VPC ID for ALB"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for ALB"
}

variable "public_subnets_by_az" {
  type        = map(string)
  description = "A map of AZs to their respective public subnets"
}
