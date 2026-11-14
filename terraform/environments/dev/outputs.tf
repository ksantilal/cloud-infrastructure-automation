output "vpc_id" {
  description = "Project VPC ID"
  value       = module.network.vpc_id
}

output "availability_zones" {
  description = "Availability Zones used by the project"
  value       = local.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "admin_public_ip" {
  description = "Public IP of Admin and Ansible server"
  value       = module.compute.admin_public_ip
}

output "admin_private_ip" {
  description = "Private IP of Admin and Ansible server"
  value       = module.compute.admin_private_ip
}

output "app_private_ips" {
  description = "Private IPs of application servers"
  value       = module.compute.app_private_ips
}

output "app_instance_ids" {
  description = "Application instance IDs"
  value       = module.compute.app_instance_ids
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}

output "ubuntu_ami_id" {
  description = "Ubuntu 24.04 AMI selected dynamically"
  value       = module.compute.ubuntu_ami_id
}

output "target_group_arn" {
  description = "ARN of the application Target Group"
  value       = module.load_balancer.target_group_arn
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch monitoring dashboard"
  value       = module.monitoring.dashboard_name
}

output "cpu_alarm_names" {
  description = "Application CPU alarms"
  value       = module.monitoring.cpu_alarm_names
}

output "status_alarm_names" {
  description = "EC2 status-check alarms"
  value       = module.monitoring.status_alarm_names
}

output "unhealthy_target_alarm_name" {
  description = "ALB unhealthy target alarm"
  value       = module.monitoring.unhealthy_target_alarm_name
}


