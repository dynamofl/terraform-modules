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


resource "kubernetes_namespace" "opentelemetry" {
  count = var.namespace_created ? 0 : 1
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "opentelemetry_application" {
  name       = "opentelemetry-collector-application-deployment"
  chart      = "opentelemetry-collector"
  repository = var.opentelemetry_chart_repo
  version    = var.opentelemetry_chart_version
  namespace  = var.namespace

  values = [templatefile("${path.module}/templates/values-application.yaml.tpl", {
    image_repository = "otel/opentelemetry-collector-contrib"
    image_tag = "0.90.1"
  })]

  depends_on = [kubernetes_namespace.opentelemetry]
}
