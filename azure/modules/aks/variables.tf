variable "use_existing" {
  description = "Flag to use an existing AKS cluster"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes"
  type        = string
  default     = "1.30.0"
}

variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name                         = string
    vm_size                      = string
    os_disk_size_gb              = number
    os_disk_type                 = string
    vnet_subnet_id               = string
    zones                        = list(string)
    auto_scaling_enabled         = bool
    min_count                    = number
    max_count                    = number
    os_sku                       = string
    only_critical_addons_enabled = bool
    upgrade_settings = object({
      max_surge                     = string
      drain_timeout_in_minutes      = number
      node_soak_duration_in_minutes = number
    })
  })
}

variable "oidc_issuer_enabled" {
  description = "Enable OIDC issuer"
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "service_mesh_profile" {
  description = "Configuration for the service mesh profile"
  type = object({
    mode                             = string
    internal_ingress_gateway_enabled = bool
    external_ingress_gateway_enabled = bool
    revisions                        = list(string)
  })
  default = {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = false
    external_ingress_gateway_enabled = true
    revisions                        = ["asm-1-22"]
  }
}

variable "workload_autoscaler_profile" {
  description = "Configuration for the workload autoscaler profile"
  type = object({
    keda_enabled = bool
  })
  default = {
    keda_enabled = true
  }
}

variable "network_profile" {
  description = "Configuration for the AKS network profile"
  type = object({
    network_plugin = string
  })
  default = {
    network_plugin = "azure"
  }
}

variable "additional_node_pools" {
  description = "Additional node pools for the AKS cluster"
  type = map(object({
    vm_size                = string
    os_disk_size_gb        = number
    os_disk_type           = string
    vnet_subnet_id         = string
    max_pods               = number
    zones                  = list(string)
    auto_scaling_enabled   = bool
    min_count              = number
    max_count              = number
    node_labels            = map(string)
    node_taints            = list(string) 
  }))
  default = {}
}
