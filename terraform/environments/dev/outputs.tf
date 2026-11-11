output "aws_account_id" {
  description = "AWS account where Terraform will deploy resources"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region used by Terraform"
  value       = data.aws_region.current.region
}
