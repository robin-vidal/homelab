# 0004. Use a PreSync hook to install large CRDs that exceed ArgoCD's annotation limit

## Status
Accepted

## Context
Some Helm charts (e.g. Envoy Gateway) ship CRDs whose OpenAPI schemas are large enough to exceed Kubernetes' 262KB annotation limit. ArgoCD's default apply strategy adds a `kubectl.kubernetes.io/last-applied-configuration` annotation containing the full resource, which causes the API server to reject the apply.

Options considered: client-side apply (default, fails), `ServerSideApply=true` in syncOptions (still fails — ArgoCD validation path triggers the limit), manual one-off apply (breaks GitOps, fresh installs require manual steps), PreSync hook.

## Decision
Install oversized CRDs via an ArgoCD PreSync hook (a Job) that runs `kubectl apply --server-side --field-manager=argocd` before the main sync. The Helm chart is deployed with `includeCRDs: false` so ArgoCD never tries to manage the CRDs itself.

## Rationale
- SSA in the hook avoids the annotation entirely; only `managedFields` is used.
- Using `--field-manager=argocd` matches ArgoCD's own SSA field manager so subsequent syncs see the CRDs as already reconciled.
- Fresh installs are fully automated — no manual step required.
- `includeCRDs: false` prevents ArgoCD from re-applying CRDs during the main sync and hitting the limit again.

## Consequences
- Each chart that has oversized CRDs needs its own `crd-installer.yaml` hook.
- CRD version is pinned in the hook command alongside the chart version; both must be updated on upgrades.
