data "talos_machine_configuration" "this" {
  for_each = var.nodes

  cluster_name     = var.cluster_name
  machine_type     = each.value.role
  cluster_endpoint = "https://${var.cluster_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = concat(
    [
      yamlencode({
        machine = {
          install = {
            disk = var.install_disk
          }
        }
      })
    ],
    each.value.role == "controlplane" ? [
      yamlencode({
        cluster = {
          allowSchedulingOnControlPlanes = var.allow_scheduling_on_controlplanes
        }
      })
    ] : []
  )
}
