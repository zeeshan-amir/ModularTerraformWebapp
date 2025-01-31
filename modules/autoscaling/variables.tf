variable "key_name" {
  type        = string
  description = "SSH Key Name for EC2 Instances"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for Django instances"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for Auto Scaling"
}

variable "ecr_image_url" {
  type        = string
  description = "ECR Image URL"
}

variable "alb_target_group_arn" {
  type        = string
  description = "Target Group ARN for ALB"
}

variable "db_host" {
  type        = string
  description = "Private IP of the PostgreSQL database"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for EC2 instances"
}
