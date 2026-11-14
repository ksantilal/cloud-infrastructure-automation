variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet used by the Admin server"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by application servers"
  type        = list(string)
}

variable "admin_security_group_id" {
  description = "Security Group ID for Admin server"
  type        = string
}

variable "app_security_group_id" {
  description = "Security Group ID for application servers"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "admin_instance_type" {
  description = "EC2 instance type for Admin server"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.micro"
}
