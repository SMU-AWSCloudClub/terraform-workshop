terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0" # sets terraform CLI version
}

provider "aws" {
  region = "ap-southeast-1"
}
