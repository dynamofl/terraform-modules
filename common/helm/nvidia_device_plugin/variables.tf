variable "namespace" {
  description = "Namespace for Nvidia Device Plugin"
  type        = string
  default     = "nvidia-device-plugin"
}

variable "kube_config" {
  description = "Kubernetes configuration for the Helm provider"
  type = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
}


variable "namespace_created" {
  description = "Flag indicating whether the namespace is created"
  type        = bool
  default     = false
}

variable "chart_version" {
  description = "Version of the Helm chart to deploy"
  type        = string
  default     = "0.14.5"  # Example version
}
