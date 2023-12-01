# General Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "eu-west-2"  
}

# AWS profile
variable "aws_profile" {
  description = "Profile in which AWS Resources to be created"
  type = string
  default = "default"  
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}

# Project
variable "project" {
  description = "Project name in the organization"
  type = string
  default = "test"
}
