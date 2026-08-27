module "talos" {
  source = "../../modules/talos-cluster"
  cluster_name     = "homelab-vps"
  cluster_endpoint = var.cluster_ip
  install_disk     = "/dev/vda"
  nodes = {
    vps = {
      ip   = var.cluster_ip
      role = "controlplane"
      extra_patches = [
        yamlencode({
          machine = {
            network = {
              interfaces = [
                {
                  interface = "ens18"
                  addresses = ["185.214.135.121/23"]
                  dhcp      = false
                  routes = [
                    {
                      network = "0.0.0.0/0"
                      gateway = "185.214.134.1"
                    }
                  ]
                }
              ]
              nameservers = ["1.1.1.1", "8.8.8.8"]
            }
          }
        })
      ]
    }
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

resource "null_resource" "wait_for_kubernetes" {
  depends_on = [local_sensitive_file.kubeconfig]

  provisioner "local-exec" {
    command = <<-EOT
      for i in $(seq 1 30); do
        if kubectl --kubeconfig=${local_sensitive_file.kubeconfig.filename} get --raw=/healthz >/dev/null 2>&1; then
          echo "Kubernetes API is ready"
          exit 0
        fi
        echo "Waiting for Kubernetes API... ($i/30)"
        sleep 5
      done
      echo "Timed out waiting for Kubernetes API"
      exit 1
    EOT
  }
}

module "argocd" {
  source = "../../modules/argocd-bootstrap"
  root_app_repo_url = "https://github.com/robin-vidal/homelab"
  root_app_path     = "kubernetes/clusters/vps"
  depends_on = [null_resource.wait_for_kubernetes]
}
