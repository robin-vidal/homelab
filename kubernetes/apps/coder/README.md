# Coder

Self-hosted cloud development environment platform, deployed via the official Coder Helm chart.

Uses a dedicated CloudNativePG PostgreSQL cluster (`coder-db`) for persistence. A ClusterRole grants the Coder service account permissions to provision workspace pods across the cluster.
