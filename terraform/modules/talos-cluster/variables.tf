variable "cluster_name" {
  description = "Name of the Talos/Kubernetes cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "IP/hostname used to reach the Kubernetes API server"
  type        = string
}

variable "install_disk" {
  description = "Target disk for the Talos installation"
  type        = string
}

variable "nodes" {
  description = "Map of nodes to provision, keyed by a unique node name"
  type = map(object({
    ip   = string
    role = string # "controlplane" or "worker"
  }))

  validation {
    condition     = alltrue([for n in var.nodes : contains(["controlplane", "worker"], n.role)])
    error_message = "Each node role must be either \"controlplane\" or \"worker\"."
  }
}

variable "allow_scheduling_on_controlplanes" {
  description = "Whether control-plane nodes also accept application workloads"
  type        = bool
  default     = false
}
