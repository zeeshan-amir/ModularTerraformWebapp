# IAM Role for EC2 Auto Scaling Instances (Django)
resource "aws_iam_role" "ec2_role" {
  name = "django-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for ECR Access
resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ECRAccessPolicy"
  description = "Allow EC2 instances to pull Docker images from ECR."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      Resource = "*"
    }]
  })
}

# IAM Policy for CloudWatch Logging (Optional, Useful for Debugging)
resource "aws_iam_policy" "cloudwatch_logging_policy" {
  name        = "CloudWatchLoggingPolicy"
  description = "Allow EC2 instances to write logs to CloudWatch."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

# IAM Policy for Auto Scaling Group to Register with ALB Target Group
resource "aws_iam_policy" "asg_alb_policy" {
  name        = "ASGRegisterALBPolicy"
  description = "Allow Auto Scaling to register instances to ALB target group."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetHealth"
      ]
      Resource = "*"
    }]
  })
}

# Attach IAM Policies to EC2 Role
resource "aws_iam_role_policy_attachment" "ecr_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "asg_alb_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.asg_alb_policy.arn
}

# IAM Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "django-instance-profile"
  role = aws_iam_role.ec2_role.name
}
