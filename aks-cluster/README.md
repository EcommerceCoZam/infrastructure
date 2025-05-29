# Documentación de Infraestructura

## 📋 Resumen Ejecutivo

Esta infraestructura implementa un cluster de Kubernetes en Azure (AKS) con almacenamiento de estado de Terraform en Google Cloud Platform, proporcionando una solución híbrida multi-cloud para aplicaciones de microservicios.

### Arquitectura General
- **Compute**: Azure Kubernetes Service (AKS)
- **Estado de Terraform**: Google Cloud Storage (GCS)
- **Orquestación**: Terraform
- **Ambientes**: dev, stage, prod

## 🏗️ Arquitectura de la Infraestructura

```
┌─────────────────────────────────────────────────────────────┐
│                        AZURE CLOUD                         │
│  ┌─────────────────────────────────────────────────────────┤
│  │               Resource Group                            │
│  │  ┌─────────────────────────────────────────────────────┤
│  │  │             AKS Cluster                             │
│  │  │  ┌─────────────┬─────────────┬─────────────────────┤
│  │  │  │ Namespace   │ Namespace   │   Namespace         │
│  │  │  │    dev      │   stage     │     prod            │
│  │  │  └─────────────┴─────────────┴─────────────────────┤
│  │  │                                                     │
│  │  │  Node Pool (Auto-scaling: 1-3 nodes)               │
│  │  │  VM Size: Standard_DS2_v2                           │
│  │  └─────────────────────────────────────────────────────┤
│  └─────────────────────────────────────────────────────────┤
└─────────────────────────────────────────────────────────────┘
                              │
                              │ Terraform State
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    GOOGLE CLOUD PLATFORM                   │
│  ┌─────────────────────────────────────────────────────────┤
│  │                 GCS Bucket                              │
│  │         certain-perigee-459722-b4-tfstate               │
│  │                                                         │
│  │  • Versioning habilitado                               │
│  │  • Uniform bucket-level access                         │
│  │  • Ubicación: US                                       │
│  └─────────────────────────────────────────────────────────┤
└─────────────────────────────────────────────────────────────┘
```

## 📁 Estructura del Proyecto

```
.
├── main.tf                    # Configuración principal
├── variables.tf               # Definición de variables
├── outputs.tf                 # Outputs del cluster
├── providers.tf               # Configuración de providers
├── terraform.tfvars           # Variables de configuración (no versionado)
└── modules/
    └── aks/
        ├── main.tf            # Recursos del cluster AKS
        ├── variables.tf       # Variables del módulo AKS
        └── outputs.tf         # Outputs del módulo AKS
```

## 🔧 Componentes de la Infraestructura

### Azure Kubernetes Service (AKS)

#### Características Principales
- **Auto-scaling**: Habilitado (1-3 nodos)
- **Versión de Kubernetes**: 1.29 (LTS)
- **Tipo de VM**: Standard_DS2_v2
- **Disco OS**: 128 GB por nodo
- **Identidad**: System Assigned Managed Identity

#### Namespaces
- `dev`: Ambiente de desarrollo
- `stage`: Ambiente de staging/pruebas
- `prod`: Ambiente de producción

### Configuración de Nodos

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| Tipo de VM | Standard_DS2_v2 | 2 vCPUs, 7 GB RAM |
| Auto-scaling | Habilitado | Escala automática según demanda |
| Nodos mínimos | 1 | Número mínimo de nodos |
| Nodos máximos | 3 | Número máximo de nodos |
| Disco OS | 128 GB | Almacenamiento por nodo |

## 🔐 Seguridad y Acceso

### Autenticación Azure
- Service Principal o Azure CLI
- Managed Identity para el cluster AKS
- RBAC habilitado por defecto

### Autenticación Google Cloud
- Service Account o gcloud CLI
- Uniform bucket-level access en GCS

### Variables Sensibles
Las siguientes variables contienen información sensible y no deben ser versionadas:

```hcl
# terraform.tfvars (ejemplo)
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
gcp_project_id  = "certain-perigee-459722-b4"
```

## 🚀 Despliegue y Operación

### Prerequisites

1. **Herramientas necesarias**:
   - Terraform >= 1.0
   - Azure CLI
   - Google Cloud SDK
   - kubectl

2. **Autenticación**:
   ```bash
   # Azure
   az login
   
   # Google Cloud
   gcloud auth application-default login
   ```

### Proceso de Despliegue

1. **Configurar variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Editar terraform.tfvars con valores reales
   ```

2. **Inicializar Terraform**:
   ```bash
   terraform init
   ```

3. **Planificar cambios**:
   ```bash
   terraform plan
   ```

4. **Aplicar configuración**:
   ```bash
   terraform apply
   ```

5. **Conectar a AKS**:
   ```bash
   az aks get-credentials --resource-group <rg-name> --name <cluster-name>
   kubectl get nodes
   ```

### Comandos Útiles

```bash
# Ver estado del cluster
kubectl get nodes
kubectl get namespaces

# Cambiar entre namespaces
kubectl config set-context --current --namespace=dev

# Ver pods en todos los namespaces
kubectl get pods --all-namespaces

# Escalar deployment
kubectl scale deployment <deployment-name> --replicas=3 -n <namespace>
```

## 📊 Monitoreo y Observabilidad

### Azure Monitor (Opcional)
- Container Insights puede ser habilitado
- Requiere Log Analytics Workspace
- Variable: `enable_azure_monitor_for_containers`

### Métricas Clave a Monitorear
- Utilización de CPU y memoria de nodos
- Número de pods por namespace
- Latencia de API server
- Disponibilidad del cluster

## 💰 Costos Estimados

### Azure AKS
| Componente | Costo Aproximado (USD/mes) | Notas |
|------------|---------------------------|-------|
| AKS Management | Gratis | Cluster management |
| VM Standard_DS2_v2 (1-3 nodos) | $70-210 | Pago por uso |
| Almacenamiento OS | $15-45 | 128GB × nodos |
| Tráfico de red | Variable | Según uso |

### Google Cloud Storage
| Componente | Costo Aproximado (USD/mes) | Notas |
|------------|---------------------------|-------|
| GCS Standard | <$1 | Solo estado de Terraform |
| Operaciones API | <$1 | Minimal usage |

**Total estimado**: $85-260 USD/mes (dependiendo del número de nodos activos)

## 🔄 Mantenimiento y Actualizaciones

### Actualizaciones de Kubernetes
```bash
# Ver versiones disponibles
az aks get-upgrades --resource-group <rg-name> --name <cluster-name>

# Actualizar cluster (con Terraform)
# Cambiar kubernetes_version en terraform.tfvars
terraform plan
terraform apply
```

### Backup del Estado
- El estado se almacena automáticamente en GCS
- Versioning habilitado para recuperación
- Considerar backup adicional para ambientes críticos

### Escalado Manual
```bash
# Escalar nodos (temporal)
az aks scale --resource-group <rg-name> --name <cluster-name> --node-count 5

# Para cambios permanentes, actualizar terraform.tfvars
```

## 🚨 Troubleshooting

### Problemas Comunes

1. **Error de autenticación Azure**:
   ```bash
   az login --tenant <tenant-id>
   ```

2. **Error de permisos GCS**:
   ```bash
   gcloud auth application-default login
   ```

3. **Cluster no responde**:
   ```bash
   kubectl get nodes
   az aks show --resource-group <rg-name> --name <cluster-name>
   ```

4. **Estado de Terraform bloqueado**:
   ```bash
   terraform force-unlock <lock-id>
   ```

### Logs Importantes
```bash
# Logs del cluster
kubectl logs -n kube-system deployment/coredns

# Eventos del cluster
kubectl get events --all-namespaces --sort-by='.lastTimestamp'

# Estado de nodos
kubectl describe nodes
```

## Recursos Adicionales
- [Azure AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---

**Última actualización**: Mayo 2025  
**Versión de la documentación**: 1.0