variable "namespace" {
  description = "Namespace for Nvidia Device Plugin"
  type        = string
  default     = "nvidia-gpu"
}

variable "namespace_created" {
  description = "Flag indicating whether the namespace is created"
  type        = bool
  default     = false
}

variable "chart_version" {
  description = "Version of the Helm chart to deploy"
  type        = string
  default     = "2.14.0"  
}
