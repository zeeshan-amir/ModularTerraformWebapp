resource "aws_launch_template" "django_lt" {
  name = "django-launch-template"
  image_id = "ami-06c6f3fa7959e5fdd"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker

              aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_image_url}
              docker pull ${var.ecr_image_url}
              docker run -d -p 8000:8000 \
                -e DB_NAME=my_prod_db \
                -e DB_USER=my_prod_user \
                -e DB_PASSWORD=my_secure_password \
                -e DB_HOST=${var.db_host} \
                -e DB_PORT=5432 \
                ${var.ecr_image_url}
              EOF
  )
}

resource "aws_autoscaling_group" "django_asg" {
  launch_template {
    id = aws_launch_template.django_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.private_subnet_ids
  min_size = 1
  max_size = 2
  desired_capacity = 1

  target_group_arns = [var.alb_target_group_arn]
}
