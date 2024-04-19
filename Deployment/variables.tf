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
  default     = "sundayadigun.com"
  description = "Domain name"
}

variable "cluster_name" {
  type        = string
  default     = "boutique-EKS"
  description = "Name of the EKS Cluster"
}
