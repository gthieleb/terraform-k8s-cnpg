# AWX Terraform Module

This Terraform module automates deployment of **AWX** to any existing Kubernetes cluster.
It installs and configures the **AWX Operator**, **CloudNativePG (CNPG)** PostgreSQL cluster, and prepares all required Kubernetes resources.
You can use it against any kubeconfig context — local (Kind, Minikube, k3d) or remote (EKS, GKE, AKS, OpenShift, bare metal).

## Features
- Zero‑manual setup of AWX Operator and CNPG on an existing Kubernetes environment
- Configurable namespace and resource names
- Automatic creation of CNPG secrets consumed by AWX
- Outputs for admin credentials and runtime configuration

---

## Usage Example

A working example is provided under [`examples/simple`](examples/simple).
This example includes a Kind cluster for demonstration, but the module itself works with any Kubernetes cluster reachable via the provider.

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "my-cluster"
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "my-cluster"
  }
}

module "awx" {
  source = "../.."
  # Optionally customize parameters such as:
  # awx_namespace = "awx"
}
```

---

## Running Terraform

### Pre-initialization: Terraform Helm Targets

Before applying the full Terraform configuration, you must first deploy the Helm-based dependencies that provision required operators.
These resources are defined in [`helm.tf`](helm.tf) as:

- `helm_release.awx_operator`
- `helm_release.cnpg`

To prevent the Terraform Kubernetes provider from failing (since it depends on these Helm resources being active), deploy them first using the **`-target`** flag:

```bash
terraform -chdir=examples/simple/ apply -target=helm_release.awx_operator -target=helm_release.cnpg
```

Once the Helm releases are deployed successfully, apply the remaining configuration:

```bash
terraform -chdir=examples/simple/ apply
```

This ensures that the Helm charts are installed and ready before any Kubernetes provider resources are created.

From the project root, run Terraform using the `-chdir` flag:

```bash
terraform -chdir=terraform/examples/simple init
terraform -chdir=terraform/examples/simple apply -auto-approve
```

Terraform will:
1. Use the configured Kubernetes provider.
2. Install CNPG and AWX Operator via Helm.
3. Apply Kubernetes manifests for namespace, secrets, and AWX CR.
4. Output the AWX admin credentials once setup completes.

---

✅ **Result:**
A ready‑to‑use AWX instance installed on your selected cluster, accessible via its service or ingress endpoint.
### Retrieve AWX Admin Credentials

After applying the Terraform configuration, you can retrieve the AWX admin credentials by running:

```bash
terraform -chdir=examples/simple/ output awx_admin_credentials
```

Example output:

```hcl
{
  "password" = "plmUiaxrP7HGsyEI0555laFn07R0y5pw"
  "username" = "admin"
}
```
### Checking the AWX Pods

You can inspect the status of all pods across namespaces to monitor AWX initialization:

```bash
kubectl get pods -A
```

Example output:

```
NAMESPACE            NAME                                                READY   STATUS      RESTARTS   AGE
awx                  awx-cnpg-1                                          1/1     Running     0          13h
awx                  awx-migration-24.6.1-5gvpp                          0/1     Completed   0          13h
awx                  awx-operator-controller-manager-7f755f5f8d-zx2t6    2/2     Running     0          13h
awx                  awx-task-6d64b668cb-kdjhv                           4/4     Running     0          13h
awx                  awx-web-7b9ffdd8bb-qxb8l                            3/3     Running     0          13h
```

> **Note:**  
> The `awx-migration` job may take several minutes to complete during the initial setup.  
> Additionally, the `awx-task` and `awx-web` pods can take a few minutes to initialize fully after the database has migrated.  
> During this period, the containers might show as `Pending`, `Init`, or `ContainerCreating`; this is expected behavior and will resolve automatically.
