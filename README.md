# Terraform Kubernetes CloudNativePG (CNPG)

This Terraform module deploys and configures CloudNativePG (CNPG) on Kubernetes. It installs the CNPG operator and SeaweedFS (as an S3-compatible storage backend) via Helm, bootstraps a 3-instance PostgreSQL 16 cluster using a CNPG `Cluster` manifest, and retrieves the superuser connection secret.

## Features

- Deploys the CNPG operator via Helm chart
- Deploys SeaweedFS with S3-compatible filer enabled (provides the S3 endpoint for future backup/restore workflows)
- Creates a CNPG `Cluster` resource (3 PostgreSQL 16 instances, 1Gi storage)
- Manages namespaces for the operator, SeaweedFS, and the database cluster
- Retrieves the CNPG superuser connection secret as a Terraform output
- Uses `lifecycle { ignore_changes }` on the cluster manifest so Terraform will not overwrite in-place changes made by the CNPG operator

## Architecture

The CNPG Operator (deployed in the `cnpg-system` namespace) manages the full PostgreSQL cluster lifecycle. The CNPG Cluster resource (in the `cnpg-projects` namespace) runs 3 PostgreSQL 16 instances with 1Gi storage each. SeaweedFS (in the `seaweedfs` namespace) provides an S3-compatible storage endpoint that will be used for future backup and restore workflows.

## Requirements

- Terraform >= 1.5.0
- Providers:
  - `hashicorp/kubernetes` >= 2.38.0
  - `hashicorp/helm` >= 3.0.0
- Note: The kind provider (for local development clusters) is used only in `examples/simple/`, not by this module itself

## Usage

```hcl
# Using remote source (GitHub)
module "cnpg" {
  source = "github.com/gthieleb/terraform-k8s-cnpg"
}
```

```hcl
# Using local source (development)
module "cnpg" {
  source = "../terraform-k8s-cnpg"
}
```

See `examples/simple/` for a complete working example including kind cluster creation.

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cnpg_chart_version` | Helm chart version for CloudNativePG operator | `string` | `"0.26.0"` |
| `seaweedfs_chart_version` | Helm chart version for SeaweedFS | `string` | `"4.0.401"` |
| `cnpg_operator_namespace` | Namespace for CNPG operator resources | `string` | `"cnpg-system"` |
| `seaweedfs_namespace` | Namespace for SeaweedFS resources | `string` | `"seaweedfs"` |
| `cnpg_cluster_namespace` | Namespace for the CNPG cluster | `string` | `"cnpg-projects"` |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `cnpg_name` | Helm release name of the CloudNativePG operator | no |
| `cnpg_cluster_name` | Name of the CNPG Cluster resource | no |
| `cnpg_cluster_secret` | Superuser connection secret for the CNPG cluster | yes |

## Roadmap

- [ ] CNPG `Backup` resource for scheduled backups to S3 (SeaweedFS)
- [ ] CNPG `Restore` resource for restoring clusters from S3 backups
- [ ] Configurable backup schedules and retention policies
- [ ] Sane default Helm values for production-ready deployments

## License

This project is licensed under the MIT License.
