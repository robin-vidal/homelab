# Envoy Gateway

CNCF Gateway API controller for the VPS cluster. Deployed via the official `gateway-helm` OCI Helm chart.

Creates a `GatewayClass` (controller: `gateway.envoyproxy.io/gatewayclass-controller`) and a `Gateway` listening on port 80. MetalLB assigns the IP to the Gateway's LoadBalancer Service.

Apps are exposed by creating `HTTPRoute` resources that reference the `vps-gateway` Gateway.
