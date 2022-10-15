variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_account_ids" {
  type    = list(any)
  default = null
}

terraform {
  required_version = ">= 0.12.20"
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = var.aws_account_ids
  profile             = "default"
  # Fix warning: moved version to required_providers block to fix a warning for a deprecated syntax
  # version             = ">= 2.46.0"
}

terraform {
  required_providers {
    aws = {
      version = ">= 2.46.0"
    }
  }
}