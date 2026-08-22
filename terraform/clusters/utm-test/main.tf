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

module "argocd" {
  source = "../../modules/argocd-bootstrap"

  kubeconfig        = module.talos.kubeconfig
  root_app_repo_url = "https://github.com/robin-vidal/homelab"
  root_app_path     = "kubernetes/clusters/utm-test"

  depends_on = [module.talos]
}
