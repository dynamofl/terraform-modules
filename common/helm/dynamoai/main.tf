provider "kubernetes" {
  host                   = var.kube_config.host
  client_certificate     = base64decode(var.kube_config.client_certificate)
  client_key             = base64decode(var.kube_config.client_key)
  cluster_ca_certificate = base64decode(var.kube_config.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = var.kube_config.host
    client_certificate     = base64decode(var.kube_config.client_certificate)
    client_key             = base64decode(var.kube_config.client_key)
    cluster_ca_certificate = base64decode(var.kube_config.cluster_ca_certificate)
  }
}


resource "kubernetes_namespace" "dynamoai" {
  count = var.namespace_created ? 0 : 1
  metadata {
    name = "dynamoai"
  }
}

resource "helm_release" "dynamoai" {
  name      = "dynamoai"
  chart     = "/Users/karandynamofl/dev/internal-charts/product-helm-charts/dynamoai-base"
  namespace = "dynamoai"

  values = [
    templatefile("${path.module}/templates/base.yaml.tpl", {
      dynamoguard_namespace   = "dynamoai-dynamoguard"
      dynamoai_namespace      = "dynamoai"
      api_domain              = var.api_domain
      ui_domain               = var.ui_domain
      keycloak_domain         = var.keycloak_domain
      storage_class           = var.storage_class
      license                 = var.license
      postgres_host           = var.postgres_host
      postgres_username       = var.postgres_username
      postgres_password       = var.postgres_password
      mistral_api_key         = var.mistral_api_key
      openai_api_key          = var.openai_api_key
      data_generation_api_key = var.data_generation_api_key
      hf_token                = var.hf_token
      keycloak_username       = var.keycloak_username
      keycloak_password       = var.keycloak_password

    })
  ]

  depends_on = [kubernetes_namespace.dynamoai]
}
