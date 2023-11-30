# Terraform Settings Block
terraform {
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.65"      
     }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }
    http = {
      source = "hashicorp/http"
      version = ">= 3.3"
    }

  }
  
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "ncti-terraform-statefile-dev"
    key    = "dev/eks-demo/terraform.tfstate"
    region = "eu-west-2" 

    # For State Locking
    dynamodb_table = "terraform-statefile-lock-eks"    
  }     

}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# Terraform HTTP Provider Block
provider "http" {
  # Configuration options
}


data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token 
}

# HELM Provider
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}