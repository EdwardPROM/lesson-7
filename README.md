# Argo CD (Terraform) + MLflow (Helm)  
_Aвтоматизація деплою з GitOps-підходом_

---

## Структура репозиторію

```

LESSON-7/
├── README.md
├── application/
│   └── application.yaml        # ArgoCD Application для MLflow (через Helm)
├── argocd/
│   ├── backend.tf              # Backend для збереження Terraform state
│   ├── main.tf                 # Розгортання ArgoCD через Helm
│   ├── outputs.tf              # Вивід значень (наприклад, пароль)
│   ├── terraform.tf            # Провайдери AWS + Kubernetes
│   ├── variables.tf            # Оголошення змінних
│   └── values/
│       └── argocd-values.yaml  # Helm values для ArgoCD
├── .gitignore
└── LICENSE

````

---

## Передумови

- Встановлено: `kubectl`, `helm`, `terraform` (версія ≥1.5)
- Налаштований доступ до Kubernetes-кластера (EKS/minikube/інший)
- Кластер має доступ до Інтернету

---

## 1 Розгортання ArgoCD через Terraform

### Перевір контекст Kubernetes:

```bash
kubectl config current-context
kubectl get nodes
````

### Ініціалізація та запуск Terraform:

```bash
cd argocd

terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### Перевір наявність подів:

```bash
kubectl get pods -n infra-tools
```

---

## 2 Доступ до UI ArgoCD

### Через port-forward:

```bash
kubectl port-forward svc/argocd-server -n infra-tools 8080:443
```

Відкрий: [https://localhost:8080](https://localhost:8080)

### Логін:

```bash
# Логін:
admin

# Пароль:
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

---

## 3 Деплой MLflow через ArgoCD Application (Helm)

### Застосування Application:

```bash
kubectl apply -n infra-tools -f application/application.yaml
```

### Перевір синхронізацію:

```bash
kubectl get applications.argoproj.io -n infra-tools mlflow
```

---

## 4 Перевірка MLflow

### Поди та сервіс:

```bash
kubectl get pods -n application
kubectl get svc  -n application
```

### Port-forward:

```bash
kubectl port-forward -n application svc/mlflow 5000:5000
```

Перейдіть: [http://localhost:5000](http://localhost:5000)

---

## 5 GitOps-підхід

* Зміни вносяться в `application.yaml` або `mlflow-values.yaml`
* ArgoCD автоматично підтягне зміни (autosync увімкнено)
* Статус — у UI або CLI:

```bash
kubectl get applications.argoproj.io -n infra-tools mlflow
```

---

## 6 Прибирання (Cleanup)

```bash
# Видалити Application (MLflow)
kubectl delete -n infra-tools -f application/application.yaml

# Видалити ArgoCD
cd argocd
terraform destroy -auto-approve
kubectl delete ns infra-tools
kubectl delete ns application
```

---

## Корисні команди

```bash
# Поди ArgoCD
kubectl get pods -n infra-tools

# Стан додатку
kubectl get applications.argoproj.io -n infra-tools

# Перезапуск MLflow
kubectl rollout restart deployment/mlflow -n application

# Повторне застосування Terraform
cd argocd && terraform apply -auto-approve
```