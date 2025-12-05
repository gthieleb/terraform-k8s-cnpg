
# Terraform Module for Kubernetes and Helm

This Terraform module sets up a Kubernetes cluster using the `kind` provider and deploys applications using the `helm` provider. It is designed to work with CloudNativePG and SeaweedFS.

## Features

- Creates a Kubernetes cluster using `kind`.
- Deploys CloudNativePG and SeaweedFS using Helm charts.
- Configures Kubernetes namespaces and secrets.

## Requirements

- Terraform >= 1.5.0
- Providers:
  - `tehcyx/kind` ~> 0.5.1
  - `hashicorp/kubernetes` >= 2.38.0
  - `hashicorp/helm` >= 3.0.0

## Usage

```hcl
module "cnpg" {
  source = "../.."

  depends_on = [kind_cluster.cnpg]
}
```

## Variables

- `cnpg_chart_version`: Helm release version for CloudNativePG (default: "0.26.0").
- `seaweedfs_chart_version`: Helm release version for SeaweedFS (default: "4.0.401").
- `cnpg_operator_namespace`: Namespace for CNPG resources (default: "cnpg-system").
- `seaweedfs_namespace`: Namespace for SeaweedFS resources (default: "seaweedfs").
- `cnpg_cluster_namespace`: Namespace for CNPG cluster (default: "cnpg-projects").

## Outputs

- `cnpg_name`: Helm release name of the CloudNativePG.
- `cnpg_cluster_name`: Name of the CNPG Kubernetes cluster resource.
- `cnpg_cluster_secret`: Secret of the CNPG cluster (sensitive).

## License

This project is licensed under the MIT License.
