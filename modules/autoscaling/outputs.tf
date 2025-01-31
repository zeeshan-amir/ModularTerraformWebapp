output "asg_name" {
  value = aws_autoscaling_group.django_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.django_lt.id
}
