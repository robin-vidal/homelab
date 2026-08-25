# 0003. Use CloudNativePG as the PostgreSQL operator for all app databases

## Status
Accepted

## Context
Several apps (starting with Nextcloud) require a relational database. Two approaches exist: use the database subchart bundled in each app's Helm chart, or deploy a shared PostgreSQL operator and provision dedicated clusters per app.

Options considered: bundled subcharts (MariaDB/PostgreSQL per app Helm chart), CloudNativePG, Zalando Postgres Operator, Percona PG Operator.

## Decision
Deploy CloudNativePG as the single PostgreSQL operator in the cluster (namespace `database`). Each app provisions its own `Cluster` resource in its own namespace.

## Rationale
- Bundled subcharts tie DB lifecycle to app chart upgrades, which is risky for data.
- CloudNativePG is a CNCF project with native backup to S3, automatic failover, and streaming replication.
- One operator manages all app databases, no duplicated tooling per app.
- Zalando operator is less actively maintained; Percona adds unnecessary complexity.

## Consequences
- All apps use PostgreSQL, not MySQL/MariaDB; app must support it (Nextcloud does).
- Adding a new app with a DB requires a `Cluster` CR in the app namespace, not a subchart toggle.
- CloudNativePG CRDs must be present before any app DB manifests are applied.
- Backups require an S3-compatible target configured per cluster.
