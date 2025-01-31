output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "django_sg_id" {
  value = aws_security_group.django_sg.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
