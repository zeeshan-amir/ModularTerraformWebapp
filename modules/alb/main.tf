resource "aws_lb" "alb" {
  name = "django-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = length(var.public_subnets_by_az) >= 2 ? slice([for k, v in var.public_subnets_by_az : v], 0, 2) : values(var.public_subnets_by_az)
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name = "django-tg"
  port = 8000
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
