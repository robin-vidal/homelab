output "namespace" {
  description = "Namespace ArgoCD is installed into"
  value       = helm_release.argocd.namespace
}
