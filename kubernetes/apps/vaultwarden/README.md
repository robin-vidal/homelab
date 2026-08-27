# Vaultwarden

Self-hosted Bitwarden-compatible password manager, deployed via the guerzon Helm chart.

Uses a dedicated CloudNativePG PostgreSQL cluster (`vaultwarden-db`) for persistence. The admin token is managed with a SOPS-encrypted secret via ksops.
