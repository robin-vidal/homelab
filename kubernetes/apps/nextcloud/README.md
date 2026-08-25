# Nextcloud

Self-hosted file sync and collaboration platform, deployed via the official Nextcloud Helm chart.

Uses a dedicated CloudNativePG PostgreSQL cluster (`nextcloud-db`) for persistence. Admin credentials are managed with SOPS-encrypted secrets via ksops.
