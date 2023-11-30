# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.65"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.20"
    }  
    time = {
      source = "hashicorp/time"
      version = "~> 0.7"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-on-aws-eks"
    key    = "dev/aws-ingress/terraform.tfstate"
    region = "eu-west-2" 

    # For State Locking
    #dynamodb_table = "dev-ingress"    
  }    
}

# Time Provider
provider "time" {
  # Configuration options
}