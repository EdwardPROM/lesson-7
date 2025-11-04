output "namespace" {
  value       = var.namespace
  description = "Namespace, де розгорнуто Argo CD"
}

output "argocd_release_version" {
  value       = try(helm_release.argocd.version, null)
  description = "Версія Helm-чарту Argo CD"
}

output "argocd_server_service_type" {
  value       = try(data.kubernetes_service_v1.argocd_server.spec[0].type, null)
  description = "Тип сервісу argocd-server (очікується ClusterIP)"
}

output "argocd_server_cluster_ip" {
  value       = try(data.kubernetes_service_v1.argocd_server.spec[0].cluster_ip, null)
  description = "ClusterIP сервісу argocd-server (для внутрішнього доступу/port-forward)"
}

output "argocd_server_ports" {
  value = try([
    for p in data.kubernetes_service_v1.argocd_server.spec[0].port :
    {
      name      = try(p.name, null)
      port      = p.port
      protocol  = try(p.protocol, null)
      target    = try(p.target_port, null)
    }
  ], [])
  description = "Порти сервісу argocd-server"
}

output "how_to_get_initial_admin_password" {
  value       = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d ; echo"
  description = "Команда для отримання initial admin password"
}

output "how_to_port_forward_ui" {
  value       = "kubectl port-forward -n ${var.namespace} svc/argo-cd-server 8080:80 && echo 'Open http://localhost:8080 (user: admin)'"
  description = "Швидкий доступ до UI через port-forward"
}
