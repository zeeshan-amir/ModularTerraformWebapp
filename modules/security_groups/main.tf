# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ALB open to internet
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "alb-sg" }
}

# Security Group for Django 
resource "aws_security_group" "django_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "django-sg" }
}

# Security Group for PostgreSQL
resource "aws_security_group" "postgres_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "postgres-sg" }
}

# Security Group for Bastion
resource "aws_security_group" "bastion_sg" {
  vpc_id = var.vpc_id

  # Allow SSH from trusted IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["39.49.86.55/32", "125.209.112.218/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-sg" }
}

# Allow ALB to reach Django
resource "aws_security_group_rule" "allow_alb_to_django" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.django_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

# Allow Django to communicate with PostgreSQL
resource "aws_security_group_rule" "allow_django_to_postgres" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.postgres_sg.id
  source_security_group_id = aws_security_group.django_sg.id
}

# Allow Bastion to SSH into Django
resource "aws_security_group_rule" "allow_bastion_to_django" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.django_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

# Allow Bastion to SSH into PostgreSQL
resource "aws_security_group_rule" "allow_bastion_to_postgres" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.postgres_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}
