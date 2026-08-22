variable "argocd_version" {
  description = "Version of the argo-cd Helm chart to install"
  type        = string
  default     = "7.7.11"
}

variable "root_app_repo_url" {
  description = "Git repository URL that ArgoCD's root app-of-apps watches"
  type        = string
}

variable "root_app_path" {
  description = "Path inside the git repo to the folder containing infrastructure.yaml and apps.yaml ApplicationSets"
  type        = string
}

variable "root_app_target_revision" {
  description = "Git branch or tag ArgoCD tracks"
  type        = string
  default     = "main"
}
