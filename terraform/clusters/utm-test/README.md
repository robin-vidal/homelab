# clusters/utm-test

> Be careful, this directory will be deleted once `clusters/prod` exists and targets real Proxmox VMs.

Throwaway environment used to validate the `talos-cluster` module against a single Talos VM running locally on UTM. Not part of the real homelab infrastructure.

## Purpose

- Validate the module works end-to-end before pointing it at real IPs.
- Safe to `tofu destroy` and delete entirely at any point.

## Usage

The target VM must already be running. Update the node IP in `main.tf` (inside the `nodes` map and `cluster_endpoint`) if the VM's IP has changed after a reset.

```bash
tofu init
tofu apply
```
