resource "aws_instance" "bastion" {
  ami = "ami-06c6f3fa7959e5fdd"
  instance_type = "t3.micro"
  key_name = var.key_name
  subnet_id = var.public_subnet_ids[0]
  security_groups = [var.security_group_id]

  tags = {
    Name = "bastion-host"
  }
}
