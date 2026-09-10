terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "coder" {}

provider "kubernetes" {
  config_path = null # uses in-cluster config
}

data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

data "coder_parameter" "repo_url" {
  name         = "repo_url"
  display_name = "Repository URL"
  description  = "Git repository to clone (HTTPS)"
  default      = "https://github.com/robin-vidal/homelab"
  mutable      = true
  order        = 1
}

data "coder_parameter" "github_token" {
  name         = "github_token"
  display_name = "GitHub Token"
  description  = "Personal Access Token with repo scope"
  mutable      = true
  order        = 2
}

resource "coder_agent" "main" {
  arch = "amd64"
  os   = "linux"

  env = {
    GITHUB_TOKEN = data.coder_parameter.github_token.value
    GIT_AUTHOR_NAME     = data.coder_workspace_owner.me.full_name
    GIT_AUTHOR_EMAIL    = data.coder_workspace_owner.me.email
    GIT_COMMITTER_NAME  = data.coder_workspace_owner.me.full_name
    GIT_COMMITTER_EMAIL = data.coder_workspace_owner.me.email
  }

  startup_script = <<-EOT
    gh auth setup-git 2>/dev/null || true
    curl -fsSL https://code-server.dev/install.sh | sh
    code-server --auth none --port 8080 &
  EOT
}

resource "coder_app" "vscode" {
  agent_id     = coder_agent.main.id
  slug         = "vscode"
  display_name = "VS Code Web"
  url          = "http://localhost:8080"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"
}

locals {
  workspace_name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
}

resource "kubernetes_persistent_volume_claim_v1" "workspace" {
  metadata {
    name      = local.workspace_name
    namespace = "coder"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
  wait_until_bound = false
}

resource "kubernetes_deployment" "workspace" {
  metadata {
    name      = local.workspace_name
    namespace = "coder"
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = local.workspace_name
    }
  }

  spec {
    replicas = data.coder_workspace.me.start_count

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = local.workspace_name
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = local.workspace_name
        }
      }

      spec {
        container {
          name  = "dev"
          image = "ghcr.io/coder/envbuilder:latest"

          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }
          env {
            name  = "CODER_AGENT_URL"
            value = data.coder_workspace.me.access_url
          }
          env {
            name  = "ENVBUILDER_GIT_URL"
            value = data.coder_parameter.repo_url.value
          }
          env {
            name  = "ENVBUILDER_GIT_USERNAME"
            value = "oauth2"
          }
          env {
            name  = "ENVBUILDER_GIT_PASSWORD"
            value = data.coder_parameter.github_token.value
          }
          env {
            name  = "ENVBUILDER_INIT_SCRIPT"
            value = coder_agent.main.init_script
          }
          env {
            name  = "GITHUB_TOKEN"
            value = data.coder_parameter.github_token.value
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "2"
              memory = "4Gi"
            }
          }

          volume_mount {
            name       = "workspace"
            mount_path = "/workspaces"
          }
        }

        volume {
          name = "workspace"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.workspace.metadata[0].name
          }
        }
      }
    }
  }
}
