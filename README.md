# 🏗️ Infraestructura EcommerceCoZam

Repositorio de infraestructura como código (IaC) para el proyecto [EcommerceCoZam](https://github.com/EstebanCoZam/ecommerce-microservice-backend-app) usando Terraform con arquitectura híbrida Azure-GCP.

## 🚀 Arquitectura

- **Compute**: Azure Kubernetes Service (AKS) 
- **State Backend**: Google Cloud Storage (GCS)
- **Ambientes**: dev, stage, prod
- **Orquestación**: Terraform

## 📁 Estructura del Repositorio

```
infrastructure/
├── README.md                    # Esta documentación
├── aks-cluster/                 # Configuración del cluster AKS
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars.example
│   ├── README.md               # Documentación detallada del AKS
│   └── modules/
│       └── aks/                # Módulo reutilizable de AKS
└── gcp-bucket/                 # Bucket para estado de Terraform
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars.example
    └── README.md               # Documentación del bucket GCS
```

## ⚡ Quick Start

### 1. Prerrequisitos
```bash
# Instalar herramientas
terraform --version  # >= 1.0
az --version         # Azure CLI
gcloud --version     # Google Cloud SDK
kubectl version      # Kubernetes CLI
```

### 2. Configurar Backend (GCS)
```bash
cd gcp-bucket/
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores
terraform init && terraform apply
```

### 3. Desplegar Cluster AKS
```bash
cd ../aks-cluster/
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores
terraform init && terraform apply
```

### 4. Conectar al Cluster
```bash
az aks get-credentials --resource-group <rg-name> --name <cluster-name>
kubectl get nodes
```

## 🔧 Componentes

| Componente | Descripción | Estado |
|------------|-------------|--------|
| **GCS Bucket** | Backend remoto para estado de Terraform | ✅ Configurado |
| **AKS Cluster** | Cluster Kubernetes con auto-scaling | ✅ Configurado |
| **Namespaces** | Separación de ambientes (dev/stage/prod) | ✅ Configurado |
| **Monitoring** | Azure Monitor (opcional) | 🔶 Configurable |

## 💰 Costos Estimados

| Servicio | Costo/mes (USD) |
|----------|----------------|
| AKS Cluster (1-3 nodos) | $85-260 |
| GCS Storage | <$1 |
| **Total** | **$85-260** |

## 🔐 Autenticación

### Azure
```bash
az login
# O usar Service Principal para CI/CD
```

### Google Cloud
```bash
gcloud auth application-default login
```

## 📚 Documentación Detallada

- **[AKS Cluster](./aks-cluster/README.md)**: Configuración completa del cluster Kubernetes
- **[GCP Bucket](./gcp-bucket/README.md)**: Setup del backend de estado de Terraform

## 🛠️ Comandos Útiles

```bash
# Ver estado de la infraestructura
terraform show

# Planificar cambios
terraform plan

# Ver recursos en Kubernetes
kubectl get all --all-namespaces

# Escalar cluster manualmente
az aks scale --resource-group <rg> --name <cluster> --node-count 3
```

## 🚨 Soporte

- **Issues**: Crear issue en este repositorio
- **Documentación**: Ver READMEs específicos en cada directorio
- **Proyecto principal**: [EcommerceCoZam](https://github.com/EstebanCoZam/ecommerce-microservice-backend-app)

## 📝 Notas Importantes

- Los archivos `terraform.tfvars` contienen información sensible y **NO** están versionados
- Usar `terraform.tfvars.example` como plantilla
- El bucket GCS debe ser creado **antes** que el cluster AKS
- Revisar costos periódicamente para optimizar recursos

---

**Mantenido por**: [EstebanCoZam](https://github.com/EstebanCoZam)  
**Última actualización**: Mayo 2025  