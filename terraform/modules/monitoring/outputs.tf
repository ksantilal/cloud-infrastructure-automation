output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.project.dashboard_name
}

output "cpu_alarm_names" {
  description = "Application CPU alarm names"
  value       = aws_cloudwatch_metric_alarm.app_cpu_high[*].alarm_name
}

output "status_alarm_names" {
  description = "EC2 status alarm names"
  value       = aws_cloudwatch_metric_alarm.instance_status_failed[*].alarm_name
}

output "unhealthy_target_alarm_name" {
  description = "ALB unhealthy target alarm name"
  value       = aws_cloudwatch_metric_alarm.unhealthy_targets.alarm_name
}
