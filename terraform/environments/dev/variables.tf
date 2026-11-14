variable "aws_region" {
  description = "AWS region used for Project 1"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "kloudbuild"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
