terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.5.1"
    }
  }

  required_version = ">= 1.5.0"
}

# Create a KIND cluster
resource "kind_cluster" "cnpg" {
  name           = "cnpg-cluster"
  wait_for_ready = true

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

# Define locals for kubeconfig decoding to ensure deterministic provider loading
locals {
  kubeconfig_decoded = yamldecode(kind_cluster.cnpg.kubeconfig)
  kubeconfig_api_url = local.kubeconfig_decoded.clusters[0].cluster.server
  kubeconfig_ca_data = base64decode(local.kubeconfig_decoded.clusters[0].cluster["certificate-authority-data"])
  kubeconfig_client_cert = try(base64decode(local.kubeconfig_decoded.users[0].user["client-certificate-data"]), null)
  kubeconfig_client_key  = try(base64decode(local.kubeconfig_decoded.users[0].user["client-key-data"]), null)
}

# (Helm provider configuration migrated to provider.tf)

module "cnpg" {
  source = "../.."

  depends_on = [kind_cluster.cnpg]
}  

output "cnpg_cluster_secret" {
  value = module.cnpg.cnpg_cluster_secret
  sensitive = true
}
 
