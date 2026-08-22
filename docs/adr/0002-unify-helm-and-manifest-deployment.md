# 0002. Unify Helm and raw manifest deployment via Kustomize helmCharts

## Status
Accepted

## Context
ArgoCD needs to deploy both raw manifests and Helm charts under the same `infrastructure/` and `apps/` folders. Using two separate ApplicationSets (one for raw manifests, one for Helm via a `helm.yaml`data file) caused both to generate an Application with the same name for the same folder, resulting in a Kubernetes ownership conflict.

## Decision
Use a single ApplicationSet per folder (`infrastructure`, `apps`). Helm-based components use a `kustomization.yaml` with the `helmCharts` field instead of a separate generator or data file.

## Rationale
- One generator per folder means no possibility of ownership conflicts between ApplicationSets.
- `helmCharts` is natively supported by Kustomize, not a custom convention.
- Adding any component (raw or Helm-based) follows the same procedure: create a folder, push.

## Consequences
- Requires Kustomize/ArgoCD versions with `helmCharts` support.
- Removes the `infrastructure-helm` / `apps-helm` ApplicationSets and the `helm.yaml` convention introduced earlier.
