# Input Variables - Placeholder file
# AWS Region
variable "image_tag" {
  description = "container image tag"
  type = string
  default = "latest"  
}

# AWS profile
variable "service_dns_prefix" {
  description = "DNS-prefix for A record on Route53"
  type = string
  default = "dev-test"  
}

variable "image_registry" {
  type = string
  default = "<ecr-repo>.eu-west-2.amazonaws.com"  
}


