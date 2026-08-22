# argocd-bootstrap

Installs ArgoCD via its official Helm chart and applies the root app-of-apps Application, pointing at a folder in a git repo containing `infrastructure.yaml` and `apps.yaml` ApplicationSets.

ArgoCD itself is owned by Terraform (this module), not by ArgoCD self-management. Only `infrastructure/` and `apps/` content in the git repo is reconciled by ArgoCD.

## Usage

```hcl
module "argocd" {
  source = "../../modules/argocd-bootstrap"

  kubeconfig         = module.talos.kubeconfig
  root_app_repo_url  = "https://github.com/robin-vidal/homelab"
  root_app_path      = "kubernetes/clusters/utm-test"
}
```
