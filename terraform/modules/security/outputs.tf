output "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "admin_security_group_id" {
  description = "Security Group ID for the Admin server"
  value       = aws_security_group.admin.id
}

output "app_security_group_id" {
  description = "Security Group ID for application servers"
  value       = aws_security_group.app.id
}


