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
    bucket = "ncti-terraform-statefile-dev"
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

# Terraform AWS Provider Block
provider "aws" {
  region = "eu-west-2"
  profile = "terraform"

}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host = data.terraform_remote_state.eks.outputs.cluster_endpoint 
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.cluster.token
}