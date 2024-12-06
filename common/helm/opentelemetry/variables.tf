variable "opentelemetry_chart_version" {
  description = "Version of the OpenTelemetry Helm chart"
  type        = string
  default     = "0.90.1"
}

variable "opentelemetry_chart_repo" {
  description = "Repository URL for the OpenTelemetry Helm chart"
  type        = string
  default     = "https://open-telemetry.github.io/opentelemetry-helm-charts"
}

variable "prometheus_port" {
  description = "Port to expose Prometheus metrics"
  type        = number
  default     = 8889
}


variable "namespace_created" {
  description = "Flag indicating whether the namespace is created"
  type        = bool
  default     = false
}

variable "namespace" {
  description = "Namespace for OpenTelemetry"
  type        = string
  default     = "opentelemetry"
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
