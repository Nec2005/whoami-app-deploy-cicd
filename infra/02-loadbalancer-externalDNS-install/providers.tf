# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.65"
     }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.9"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.3"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.20"
    }      
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "ncti-terraform-statefile-dev"
    key    = "dev/k8s/terraform.tfstate"
    region = "eu-west-2" 

    # For State Locking
    #dynamodb_table = "terraform-statefile-lock-k8s"    
  }     
}

# Terraform AWS Provider Block
provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# Terraform HTTP Provider Block
provider "http" {
  # Configuration options
}

# Datasource: EKS Cluster Auth 
data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

# HELM Provider
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}