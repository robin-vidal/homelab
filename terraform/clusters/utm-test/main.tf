module "talos" {
  source = "../../modules/talos-cluster"
  cluster_name     = "homelab-utm-test"
  cluster_endpoint = "192.168.64.2"
  install_disk     = "/dev/vda"
  nodes = {
    utm-test = { ip = "192.168.64.2", role = "controlplane" }
  }
  allow_scheduling_on_controlplanes = true
}

output "kubeconfig" {
  value     = module.talos.kubeconfig
  sensitive = true
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.talos.kubeconfig
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

module "argocd" {
  source = "../../modules/argocd-bootstrap"

  root_app_repo_url = "https://github.com/robin-vidal/homelab"
  root_app_path     = "kubernetes/clusters/utm-test"

  helm_apps = {
    prometheus = "${path.module}/../../../kubernetes/infrastructure/prometheus/application.yaml"
  }

  depends_on = [local_sensitive_file.kubeconfig]
}
