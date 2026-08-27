# MetalLB

Bare-metal load balancer for the VPS cluster. Deployed via the official MetalLB Helm chart in L2 mode.

Assigns the IP to LoadBalancer Services via the `vps-pool` IPAddressPool. Used by Envoy Gateway to expose the cluster on the public VPS IP.
