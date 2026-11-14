resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "admin" {
  name        = "${var.project_name}-${var.environment}-admin-sg"
  description = "Security group for Admin and Ansible server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-admin-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for private application servers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.app_port
  ip_protocol = "tcp"
  to_port     = var.app_port

  description = "Allow application traffic from the internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.app_port
  ip_protocol                  = "tcp"
  to_port                      = var.app_port

  description = "Allow ALB traffic to application servers"
}

resource "aws_vpc_security_group_ingress_rule" "admin_ssh" {
  security_group_id = aws_security_group.admin.id

  cidr_ipv4   = var.admin_cidr
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  description = "Allow SSH from approved administrator CIDR"
}

resource "aws_vpc_security_group_egress_rule" "admin_all" {
  security_group_id = aws_security_group.admin.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic from admin server"
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.app_port
  ip_protocol                  = "tcp"
  to_port                      = var.app_port

  description = "Allow application traffic only from ALB"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_admin" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.admin.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22

  description = "Allow SSH from Admin and Ansible server"
}

resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic through NAT Gateway"
}

