variable "prefix" {
  type        = string
  default     = "boutique"
  description = "Prefix resource names"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "VPC CIDR range"
}

variable "domain_name" {
  type        = string
  default     = "drayco.com"
  description = "Domain name"
}

variable "cluster_name" {
  type        = string
  default     = "boutique-EKS"
  description = "Name of the EKS Cluster"
}

variable "oidc_issuer" {
  type        = string
  default     = "oidc.eks.us-east-1.amazonaws.com/id/5F43A6DD610A5542C68E94BB3EDE7427"
  description = "OIDC issuer of the EKS Cluster"
}
