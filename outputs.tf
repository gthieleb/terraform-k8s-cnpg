output "cnpg_name" {
  description = "Helm release name of the CloudNativePG"
  value       = helm_release.cnpg.name
}

output "cnpg_cluster_name" {
  description = "Name of the CNPG Kubernetes cluster resource"
  value       = kubernetes_manifest.cnpg_cluster.manifest.metadata.name
}

output "cnpg_cluster_secret" {
  description = "Secret of the CNPG cluster"
  value       = data.kubernetes_secret_v1.cnpg_superuser
  sensitive   = true
}
