variable "region" {
  type        = string
  description = "AWS region to deploy resources"
  default = "ap-northeast-1"
}

variable "key_name" {
  type        = string
  description = "SSH Key Name for EC2 Instances"
  default = "my-django-template-ssh"
}

variable "ecr_image_url" {
  type        = string
  description = "ECR Image URL for Django App"
  default = "007565784875.dkr.ecr.ap-northeast-1.amazonaws.com/django-app:latest"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
