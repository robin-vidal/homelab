# talos-cluster

Bootstraps a Talos Linux Kubernetes cluster on an arbitrary set of nodes.

## Usage

```hcl
module "talos" {
  source = "../../modules/talos-cluster"

  cluster_name     = "prod"
  cluster_endpoint = "192.168.1.10"
  install_disk     = "/dev/sda"

  nodes = {
    nuc1-cp = { ip = "192.168.1.10", role = "controlplane" }
    nuc1-wk = { ip = "192.168.1.20", role = "worker" }
  }

  allow_scheduling_on_controlplanes = false
}

output "kubeconfig" {
  value     = module.talos.kubeconfig
  sensitive = true
}
```

## Notes

- Bootstrap only targets a single control-plane node; etcd handles cluster formation from there.
- `allow_scheduling_on_controlplanes` should be `true` only for single-node or very small clusters.
- `cluster_endpoint` must become a VIP (not a single node IP) once more than one control-plane exists. Changing it after the fact requires regenerating configs and certs.
