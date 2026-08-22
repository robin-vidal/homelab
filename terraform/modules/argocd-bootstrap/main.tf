resource "local_sensitive_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_path = local_sensitive_file.kubeconfig.filename
  }
}

provider "kubectl" {
  config_path = local_sensitive_file.kubeconfig.filename
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  namespace        = "argocd"
  create_namespace = true

  depends_on = [local_sensitive_file.kubeconfig]
}

resource "kubectl_manifest" "root_app" {
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.root_app_repo_url
        targetRevision = var.root_app_target_revision
        path           = var.root_app_path
      }
      destination = {
        server = "https://kubernetes.default.svc"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  })

  depends_on = [helm_release.argocd]
}
