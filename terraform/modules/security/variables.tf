variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR allowed to SSH to the admin server"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}
