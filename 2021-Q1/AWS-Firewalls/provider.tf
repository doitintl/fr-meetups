terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}
