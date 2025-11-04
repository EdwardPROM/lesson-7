locals {
  repo_url = "https://argoproj.github.io/argo-helm"
}

# Namespace під інструменти
resource "kubernetes_namespace_v1" "infra_tools" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# Встановлюємо Argo CD як Helm-реліз
resource "helm_release" "argocd" {
  name       = var.release_name
  repository = local.repo_url
  chart      = "argo-cd"
  namespace  = var.namespace
  version    = var.chart_version         

  create_namespace = false
  values           = [file(var.values_file)]

  # Страховки
  wait            = true
  wait_for_jobs   = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 600

  depends_on = [kubernetes_namespace_v1.infra_tools]
}

# Дані про сервіс (для ClusterIP покаже внутрішню IP/порт)
data "kubernetes_service_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = var.namespace
  }
  depends_on = [helm_release.argocd]
}
