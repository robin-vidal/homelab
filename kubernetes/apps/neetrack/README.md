# Neetrack

Self-hosted Neetcode 150 tracker with spaced repetition, deployed via the OCI Helm chart from `ghcr.io/robin-vidal/charts`.

Uses a dedicated CloudNativePG PostgreSQL cluster (`neetrack-db`) for persistence. A kustomize patch maps the CNPG `uri` secret key to the `DATABASE_URL` env var expected by the app.
