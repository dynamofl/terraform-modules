resource "kubernetes_namespace" "keda" {
  count = var.namespace_created ? 0 : 1
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  namespace  = var.namespace
  version    = var.chart_version

  # values = [
  #   templatefile("${path.module}/values.yaml.tpl", {
  #   })
  # ]

  depends_on = [kubernetes_namespace.keda]
}
