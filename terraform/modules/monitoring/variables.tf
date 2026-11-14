variable "project_name" {
  description = "Project name used for monitoring resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "admin_instance_id" {
  description = "Admin EC2 instance ID"
  type        = string
}

variable "app_instance_ids" {
  description = "Application EC2 instance IDs"
  type        = list(string)
}

variable "alb_arn_suffix" {
  description = "Application Load Balancer ARN suffix"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target Group ARN suffix"
  type        = string
}
