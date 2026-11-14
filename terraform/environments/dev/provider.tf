provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Cloud-Infrastructure-Automation"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Training    = "Vyomanant-Academy"
    }
  }
}
