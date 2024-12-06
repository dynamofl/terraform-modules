terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "7862df0e-04c1-4bc2-83c7-d708e95b49a1"
  features {}
}

provider "kubernetes" {
  host                   = module.aks.kube_config.host
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
}

# Resource Group
module "resource_group" {
  source                       = "./modules/resource_group"
  name                         = var.resource_group_name
  location                     = var.location
  use_existing                 = var.use_existing_rg
  existing_resource_group_name = var.existing_rg_name
}

# Virtual Network
module "virtual_network" {
  source                = "./modules/virtual_network"
  use_existing_vnet     = var.use_existing_vnet
  resource_group_name   = module.resource_group.name
  existing_vnet_name    = var.existing_vnet_name
  existing_subnet_names = var.existing_subnet_names
  location              = null
}

# AKS
module "aks" {
  source                    = "./modules/aks"
  cluster_name              = var.aks_name
  location                  = var.location
  resource_group_name       = module.resource_group.name
  dns_prefix                = "dynamoai-azure"
  kubernetes_version        = "1.30.0"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool = {
    name                         = "agentpool"
    vm_size                      = "Standard_D8ds_v5"
    os_disk_size_gb              = 128
    os_disk_type                 = "Ephemeral"
    vnet_subnet_id               = module.virtual_network.subnet_ids[var.existing_subnet_names[0]]
    zones                        = ["1", "2", "3"]
    auto_scaling_enabled         = true
    min_count                    = 1
    max_count                    = 5
    os_sku                       = "Ubuntu"
    only_critical_addons_enabled = true
    upgrade_settings = {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
  }

  additional_node_pools = {
    "userpool" = {
      vm_size                = "Standard_D16ds_v5"
      os_disk_size_gb        = 128
      os_disk_type           = "Ephemeral"
      vnet_subnet_id         = module.virtual_network.subnet_ids[var.existing_subnet_names[0]]
      max_pods               = 110
      zones                  = ["1", "2", "3"]
      auto_scaling_enabled   = true
      min_count              = 0
      max_count              = 20
      node_public_ip_enabled = false
      node_taints            = []
      node_labels            = {}
    }

    "gpua100" = {
      vm_size         = "Standard_NC48ads_A100_v4"
      os_disk_size_gb = 128
      os_disk_type    = "Ephemeral"
      vnet_subnet_id  = module.virtual_network.subnet_ids[var.existing_subnet_names[0]]
      max_pods        = 30
      zones           = ["1", "2", "3"]
      node_labels = {
        "node-type" = "gpu"
      }
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 2
      node_taints          = ["nvidia.com/gpu=true:NoSchedule"]
    }

    "gpunp48a10" = {
      vm_size                = "Standard_NV36ads_A10_v5"
      os_disk_size_gb        = 128
      os_disk_type           = "Ephemeral"
      vnet_subnet_id         = azurerm_subnet.aks_subnet.id
      max_pods               = 30
      zones                  = ["1", "2", "3"]
      auto_scaling_enabled   = true
      min_count              = 0
      max_count              = 8
      node_public_ip_enabled = false
      node_taints            = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a10g:NoSchedule"]
    },
  }
}

module "nvidia_device_plugin" {
  source      = "../common/helm/nvidia_device_plugin"
  kube_config = module.aks.kube_config
}

module "opentelemetry" {
  source      = "../common/helm/opentelemetry"
  kube_config = module.aks.kube_config
}

data "kubernetes_service" "istio_ingressgateway" {
  metadata {
    name      = "aks-istio-ingressgateway-external"
    namespace = "aks-istio-ingress"
  }
}

output "istio_ingressgateway_ip" {
  value = data.kubernetes_service.istio_ingressgateway.status[0].load_balancer[0].ingress[0].ip
}

# module "dynamoai" {
#   source          = "../common/helm/dynamoai"
#   api_domain      = "http://${data.kubernetes_service.istio_ingressgateway.status[0].load_balancer[0].ingress[0].ip}/api"
#   keycloak_domain = "http://${data.kubernetes_service.istio_ingressgateway.status[0].load_balancer[0].ingress[0].ip}/keycloak"
#   postgres_host     = ""
#   postgres_username = ""
#   postgres_password = ""
#   ui_domain       = "http://${data.kubernetes_service.istio_ingressgateway.status[0].load_balancer[0].ingress[0].ip}"
#   kube_config     = module.aks.kube_config
# }
