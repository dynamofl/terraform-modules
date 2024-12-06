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


resource "kubernetes_namespace" "nvidia_device_plugin" {
  count = var.namespace_created ? 0 : 1
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nvidia_device_plugin" {
  name       = "nvidia-device-plugin"
  chart      = "nvidia-device-plugin"
  repository = "https://nvidia.github.io/k8s-device-plugin"
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
    })
  ]

  depends_on = [kubernetes_namespace.nvidia_device_plugin]
}
