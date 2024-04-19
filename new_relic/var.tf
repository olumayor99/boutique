variable "accountId" {
  type        = string
  default     = ""
  description = "New Relic Account ID"
}

variable "new_relic_key" {
  type        = string
  default     = ""
  description = "New Relic API Key"
}

variable "pixie_api_key" {
  type        = string
  default     = ""
  description = "Pixie API Key"
}
variable "pixie_deploy_key" {
  type        = string
  default     = ""
  description = "Pixie Deploy Key"
}
variable "global_license_key" {
  type        = string
  default     = "eu01xx47b6efac927be0b65afd2fe9aeFFFFNRAL"
  description = "Global License Key"
}
variable "kubernetes_cluster_name" {
  type        = string
  default     = "boutique-EKS"
  description = "Kubernetes Cluster Name"
}
variable "new_relic_version" {
  type        = string
  default     = "5.0.69"
  description = "New Relic Version"
}