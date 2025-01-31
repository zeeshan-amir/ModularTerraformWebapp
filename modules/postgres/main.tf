resource "aws_instance" "postgres" {
  ami = "ami-06c6f3fa7959e5fdd"
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = var.private_subnet_ids[0]
  security_groups = [var.security_group_id]

  tags = {
    Name = "postgres-instance"
  }
}

