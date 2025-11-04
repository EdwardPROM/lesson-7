variable "namespace" {
  description = "Namespace для Argo CD"
  type        = string
  default     = "infra-tools"
  validation {
    condition     = length(trimspace(var.namespace)) > 0
    error_message = "Namespace не може бути порожнім."
  }
}


variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія чарту argo-cd з argo-helm (семвер). Якщо null — візьметься остання."
  type        = string
  default     = null

  validation {
    condition     = var.chart_version == null || can(regex("^\\d+\\.\\d+\\.\\d+(-.*)?$", var.chart_version))
    error_message = "chart_version має бути у форматі семвер (наприклад, 7.7.11) або null."
  }
}

variable "kubeconfig_path" {
  description = "Шлях до kubeconfig. Якщо null — використаємо ~/.kube/config через pathexpand()."
  type        = string
  default     = null
}

variable "kubeconfig_context" {
  description = "Kube context (якщо декілька контекстів у kubeconfig). Якщо null — використається поточний."
  type        = string
  default     = null
}

variable "values_file" {
  description = "Шлях до values для Argo CD"
  type        = string
  default     = "./values/argocd-values.yaml"
}
