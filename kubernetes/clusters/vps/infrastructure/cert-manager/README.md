# cert-manager

Deploys cert-manager v1.21.1 for automatic TLS certificate management via Let's Encrypt.

## Secret

`secrets/cloudflare-token.yaml`: SOPS-encrypted Cloudflare API token with `Zone:Zone:Read` and `Zone:DNS:Edit`.

## Certificate

Secret are created in the `envoy-gateway-system` namespace so the Gateway can reference it directly for TLS termination.
