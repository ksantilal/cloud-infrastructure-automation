data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = file(pathexpand(var.ssh_public_key_path))

  tags = {
    Name = "${var.project_name}-${var.environment}-key"
  }
}

resource "aws_instance" "admin" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.admin_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.admin_security_group_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-${var.environment}-admin"
    Role = "Admin-Ansible"
  }
}

resource "aws_instance" "app" {
  count = length(var.private_subnet_ids)

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.app_instance_type
  subnet_id                   = var.private_subnet_ids[count.index]
  vpc_security_group_ids      = [var.app_security_group_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = false

  tags = {
    Name = "${var.project_name}-${var.environment}-app-${count.index + 1}"
    Role = "Application"
  }
}


