data "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                  = local.bootstrap_node_ip

  depends_on = [talos_machine_bootstrap.this]
}

output "kubeconfig" {
  description = "Admin kubeconfig for the created cluster"
  value       = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "client_configuration" {
  description = "Talos client configuration, reusable to manage this cluster without re-reading secrets"
  value       = talos_machine_secrets.this.client_configuration
  sensitive   = true
}
