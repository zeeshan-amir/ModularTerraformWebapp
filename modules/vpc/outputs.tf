output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_azs" {
  value = aws_subnet.public[*].availability_zone
}

output "public_subnets_by_az" {
    value = {
    for index, subnet in aws_subnet.public :
    aws_subnet.public[index].availability_zone => subnet.id
  }
}
