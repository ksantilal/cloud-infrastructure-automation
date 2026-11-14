output "admin_instance_id" {
  description = "EC2 instance ID of the Admin server"
  value       = aws_instance.admin.id
}

output "admin_public_ip" {
  description = "Public IP address of the Admin server"
  value       = aws_instance.admin.public_ip
}

output "admin_private_ip" {
  description = "Private IP address of the Admin server"
  value       = aws_instance.admin.private_ip
}

output "app_instance_ids" {
  description = "EC2 instance IDs of application servers"
  value       = aws_instance.app[*].id
}

output "app_private_ips" {
  description = "Private IP addresses of application servers"
  value       = aws_instance.app[*].private_ip
}

output "ssh_key_name" {
  description = "AWS EC2 key pair name"
  value       = aws_key_pair.this.key_name
}

output "ubuntu_ami_id" {
  description = "Ubuntu AMI selected for instances"
  value       = data.aws_ami.ubuntu.id
}
