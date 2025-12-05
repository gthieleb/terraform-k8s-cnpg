variable "cnpg_chart_version" {
  description = "Helm release name for CloudNativePG"
  type        = string
  default     = "0.26.0"
}

variable "seaweedfs_chart_version" {
  description = "Helm release name for CloudNativePG"
  type        = string
  default     = "4.0.401"
}

variable "cnpg_operator_namespace" {
  description = "Namespace for CNPG resources"
  type        = string
  default     = "cnpg-system"
}

variable "seaweedfs_namespace" {
  description = "Namespace for CNPG resources"
  type        = string
  default     = "seaweedfs"
}

variable "cnpg_cluster_namespace" {
  description = "Namespace for CNPG resources"
  type        = string
  default     = "cnpg-projects"
}
