provider "helm" {
  kubernetes = {
    host                   = local.kubeconfig_api_url
    client_certificate     = local.kubeconfig_client_cert
    client_key             = local.kubeconfig_client_key
    cluster_ca_certificate = local.kubeconfig_ca_data
  }
}

# Use kubeconfig output for both Helm and Kubernetes providers directly
provider "kubernetes" {
  host                   = local.kubeconfig_api_url
  cluster_ca_certificate = local.kubeconfig_ca_data
  client_certificate     = local.kubeconfig_client_cert
  client_key             = local.kubeconfig_client_key
}