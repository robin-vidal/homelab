# Reloader

Watches ConfigMaps and Secrets and automatically rolls the dependent Deployments/StatefulSets when they change. Deployed via the Stakater Reloader Helm chart with `watchGlobally: true`.

Primarily here to restart `argocd-repo-server` when `argocd-cm` or the age key Secret change, without manual intervention.
