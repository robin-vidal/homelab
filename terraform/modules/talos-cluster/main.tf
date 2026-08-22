locals {
  # Pick the first control-plane node as the bootstrap target.
  # Bootstrap only needs to happen once, against any single control-plane.
  bootstrap_node_ip = [
    for n in var.nodes : n.ip if n.role == "controlplane"
  ][0]
}
