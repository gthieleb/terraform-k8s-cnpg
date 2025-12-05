# Deploy CloudNativePG via Helm
resource "helm_release" "cnpg" {
  name             = "cnpg"
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  namespace        = var.cnpg_operator_namespace
  version          = var.cnpg_chart_version
  create_namespace = true
}

resource "helm_release" "seaweedfs" {
  name = "seaweedfs"
  repository = "https://seaweedfs.github.io/seaweedfs/helm"
  chart = "seaweedfs"
  namespace        = var.seaweedfs_namespace
  version          = var.seaweedfs_chart_version
  create_namespace = true
  set = [
    {
      name = "filer.s3.enabled" 
      value = "true"
    }
  ]
}

resource "kubernetes_namespace_v1" "cnpg_cluster" {
  metadata {
    name = var.cnpg_cluster_namespace
  }
}

# Retrieve CNPG superuser secret after cluster creation
data "kubernetes_secret_v1" "cnpg_superuser" {
  metadata {
    name      = "cnpg-projects-cnpg-app"
    namespace = var.cnpg_cluster_namespace
  }

  depends_on = [
    kubernetes_manifest.cnpg_cluster
  ]
}

resource "kubernetes_manifest" "cnpg_cluster" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"
    metadata = {
      name      = "cnpg-projects"
      namespace = var.cnpg_cluster_namespace
    }
    spec = {
      instances = 3
      imageName = "ghcr.io/cloudnative-pg/postgresql:16"
      storage = {
        size = "1Gi"
      }
    }
  }

  lifecycle {
    ignore_changes = [manifest]
  }

  depends_on = [kubernetes_namespace_v1.cnpg_cluster]

}
