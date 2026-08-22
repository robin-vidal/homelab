# 0001. Use Talos Linux for the Kubernetes nodes

## Status
Accepted

## Context
An OS is needed for the Kubernetes nodes (control-plane and worker). As of this decision, the pipeline is being validated against a single Talos OS VM running locally on UTM; no Proxmox instance exists yet.

Options considered: standard Linux distro (Debian/Ubuntu), + kubeadm + Ansible, k3s on a lightweight distro, or Talos Linux.

## Decision
Use Talos Linux as the node OS, managed entirely through it's gRPC API (official CLI and/or Terraform provider).

## Rationale
- No SSH, no shell, no package manager: eliminates config drift and removes the need for Ansible entirely.
- Machine config is a single declarative YAML per node, applied atomically. Fits the full IaC/GitOps goal directly, no imperative provisioning step.
- Immutable, API-driven upgrades instead of in-place package updates.
- Terraform provider is first-class and actively maintained.
- Aligns with personal learning goal (SRE track, distributed systems, direct etcd experience).

## Consequences
- No shell access for debugging; all diagnostics go through the CLI or the serial console dashboard.
- Smaller ecosystem/community than mainstream distros: fewer StackOverflow answers, more official docs reliance.
- Requires learning Talos-specific concepts (machine config, maintenance mode, secrets bundle) instead of reusing general Linux admin knowledge.
- Decision validated on a local UTM VM first; behavior on real Proxmox VMs (disk naming, network interface naming) still needs confirmation once real hardware is available.
