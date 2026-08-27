# clusters/vps

Contabo VPS cluster running live workloads while NUC hardware is in transit.
Single-node Talos (controlplane + worker), bootstrapped via the `talos-cluster` module.

## Purpose

- Host live services (homepage, nextcloud, vaultwarden, …)
- Staging ground for infra patterns before migration to NUCs

## Usage

Talos must already be installed on the VPS. Update `terraform.tfvars` with the VPS public IP.

```bash
tofu init
tofu apply
```

## Notes

Will be decommissioned or repurposed as edge/reverse-proxy once the NUC cluster is live.
