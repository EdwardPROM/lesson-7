terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"   # фіксуємо мажор/мінор
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

# Провайдер Kubernetes бере kubeconfig з шляху/контексту
provider "kubernetes" {
  # дефолт на випадок, якщо var.kubeconfig_path не заданий
  config_path    = coalesce(var.kubeconfig_path, pathexpand("~/.kube/config"))
  config_context = var.kubeconfig_context
}

# Helm підключається до того ж кластера через kubernetes-блок
provider "helm" {
  kubernetes {
    config_path    = coalesce(var.kubeconfig_path, pathexpand("~/.kube/config"))
    config_context = var.kubeconfig_context
  }
}
