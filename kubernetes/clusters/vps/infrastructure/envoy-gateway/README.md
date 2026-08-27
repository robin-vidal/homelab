# Envoy Gateway

CNCF Gateway API controller for the VPS cluster. Deployed via the official `gateway-helm` OCI Helm chart.

Creates a `GatewayClass` (controller: `gateway.envoyproxy.io/gatewayclass-controller`) and a `Gateway` listening on port 80. MetalLB assigns the IP to the Gateway's LoadBalancer Service.

Apps are exposed by creating `HTTPRoute` resources that reference the `vps-gateway` Gateway.

## CRD installation

Some Envoy Gateway CRDs exceed Kubernetes' 262KB annotation limit and cannot be applied by ArgoCD via standard sync. A PreSync hook (`crd-installer.yaml`) runs before each sync and applies them via `kubectl apply --server-side --field-manager=argocd`. The Helm chart itself uses `includeCRDs: false` to prevent ArgoCD from re-applying them.
