output "alb_dns" {
  value = module.alb.alb_dns_name
}

output "asg_name" {
  value = module.autoscaling.asg_name
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}
