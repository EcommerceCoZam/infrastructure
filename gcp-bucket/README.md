# GCP Storage Bucket para Terraform State

Este directorio contiene la configuración de Terraform para crear un bucket de Google Cloud Storage que se usará para almacenar el estado de Terraform del proyecto [EcommerceGZam](https://github.com/EstebanGZam/ecommerce-microservice-backend-app).

## 📋 Descripción

El bucket GCS actúa como backend remoto para el estado de Terraform, proporcionando:
- **Almacenamiento seguro** del archivo de estado
- **Versionado automático** para recuperación ante errores
- **Acceso concurrente** controlado con bloqueo de estado
- **Durabilidad** y disponibilidad alta

## 📁 Estructura de archivos

```
gcp-bucket/
├── main.tf              # Configuración principal del bucket
├── variables.tf         # Definición de variables
├── outputs.tf           # Outputs del bucket creado
├── terraform.tfvars     # Valores para las variables (no versionado)
├── .terraform/          # Archivos internos de Terraform
└── README.md           # Esta documentación
```

## ⚡ Quick Start

```bash
# 1. Clonar y configurar
git clone <repository-url>
cd gcp-bucket

# 2. Configurar variables
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# 3. Autenticarse con GCP
gcloud auth application-default login

# 4. Desplegar
terraform init
terraform apply
```

## 🔧 Prerequisitos

### 1. Google Cloud SDK
```bash
# Instalar gcloud CLI (Linux/macOS)
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Verificar instalación
gcloud --version
```

### 2. Terraform
```bash
# Instalar Terraform (Linux)
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verificar instalación
terraform --version
```

### 3. Permisos GCP Requeridos
Tu cuenta necesita los siguientes roles:
- `Storage Admin` o `Storage Object Admin`
- `Project IAM Admin` (si necesitas configurar service accounts)

```bash
# Verificar permisos actuales
gcloud projects get-iam-policy certain-perigee-459722-b4 \
  --flatten="bindings[].members" \
  --filter="bindings.members:user:$(gcloud config get-value account)"
```

## 🚀 Configuración y Despliegue

### 1. Autenticación con GCP

```bash
# Opción 1: Usando tu cuenta personal (desarrollo)
gcloud auth login
gcloud config set project certain-perigee-459722-b4
gcloud auth application-default login

# Opción 2: Usando Service Account (producción)
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
```

### 2. Configurar Variables

Crea y edita `terraform.tfvars`:

```hcl
# GCP Configuration
project_id = "certain-perigee-459722-b4"
region     = "us-central1"

# Bucket Configuration
bucket_name     = "certain-perigee-459722-b4-tfstate"
bucket_location = "US"
storage_class   = "STANDARD"

# Bucket Settings
enable_versioning            = true
uniform_bucket_level_access  = true
force_destroy               = false  # ⚠️ Set to true only for testing
prevent_destroy             = true   # ⚠️ Set to false if you need to destroy

# Labels
labels = {
  purpose     = "terraform-state"
  environment = "production"
  project     = "ecommerce-microservices"
  managed-by  = "terraform"
  team        = "devops"
}

# Lifecycle Rules (opcional)
lifecycle_rules = [
  {
    age    = 365  # Eliminar versiones después de 1 año
    action = "Delete"
  }
]
```

### 3. Desplegar Infraestructura

```bash
# Inicializar Terraform
terraform init

# Validar configuración
terraform validate

# Planificar cambios
terraform plan

# Aplicar configuración
terraform apply

# Ver outputs
terraform output
```

## 🔄 Uso en Otros Proyectos

Una vez creado el bucket, configúralo como backend en otros proyectos:

```hcl
# En main.tf de otros proyectos
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "gcs" {
    bucket = "certain-perigee-459722-b4-tfstate"
    prefix = "terraform/state"
  }
}
```

### Migrar Estado Existente

Si ya tienes estado local y quieres migrarlo:

```bash
# Inicializar con migración
terraform init -migrate-state

# O forzar copia desde estado local
terraform init -force-copy
```

## 🔐 Configuraciones de Seguridad

### Características Habilitadas

| Característica | Estado | Descripción |
|----------------|--------|-------------|
| **Versioning** | ✅ Habilitado | Mantiene historial de cambios |
| **Uniform Bucket Access** | ✅ Habilitado | Control de acceso simplificado |
| **Prevent Destroy** | ✅ Habilitado | Protege contra eliminación accidental |
| **Encryption** | ✅ Por defecto | Encriptación en reposo automática |

### Mejores Prácticas Implementadas

- **Versionado**: Recuperación ante errores en el estado
- **Lifecycle rules**: Limpieza automática de versiones antiguas
- **Uniform access**: Gestión de permisos centralizada
- **Labels**: Organización y billing por proyecto/equipo

## 🛠️ Operaciones Comunes

### Ver Estado del Bucket
```bash
# Información del bucket
gsutil ls -L gs://certain-perigee-459722-b4-tfstate

# Ver objetos en el bucket
gsutil ls gs://certain-perigee-459722-b4-tfstate/**

# Ver versiones de un objeto
gsutil ls -a gs://certain-perigee-459722-b4-tfstate/terraform/state/default.tfstate
```

### Backup Manual del Estado
```bash
# Descargar estado actual
gsutil cp gs://certain-perigee-459722-b4-tfstate/terraform/state/default.tfstate ./backup/

# Restaurar desde backup (en caso de emergencia)
gsutil cp ./backup/default.tfstate gs://certain-perigee-459722-b4-tfstate/terraform/state/
```

### Limpiar Versiones Antiguas
```bash
# Listar versiones antiguas
gsutil ls -a gs://certain-perigee-459722-b4-tfstate/terraform/state/

# Eliminar versión específica (usar con cuidado)
gsutil rm gs://certain-perigee-459722-b4-tfstate/terraform/state/default.tfstate#<version>
```

## 🚨 Troubleshooting

### Error: Bucket name already exists
```bash
# Los nombres de bucket deben ser globalmente únicos
# Cambiar en terraform.tfvars:
bucket_name = "mi-proyecto-tfstate-$(date +%s)"
```

### Error: Permission denied
```bash
# Verificar autenticación
gcloud auth list

# Re-autenticarse si es necesario
gcloud auth application-default login

# Verificar permisos del proyecto
gcloud projects get-iam-policy certain-perigee-459722-b4
```

### Error: State locked
```bash
# Ver información del lock
terraform force-unlock <LOCK_ID>

# O esperar a que expire automáticamente (15 minutos)
```

### Error: Backend initialization failed
```bash
# Limpiar y reinicializar
rm -rf .terraform
terraform init
```

## 💰 Costos

### Estimación Mensual (USD)

| Componente | Cantidad | Costo/mes |
|------------|----------|-----------|
| **Storage STANDARD** | <1 GB | $0.02 |
| **Class A Operations** | ~100 | $0.01 |
| **Class B Operations** | ~1000 | $0.01 |
| **Total Estimado** | - | **<$0.05** |

> 💡 El costo es mínimo ya que solo almacena archivos de estado de Terraform

## 📊 Monitoreo

### Métricas Importantes
- **Uso de almacenamiento**: Verificar crecimiento del estado
- **Operaciones API**: Monitorear accesos frecuentes
- **Versiones acumuladas**: Limpiar versiones antiguas

### Alertas Recomendadas
```bash
# Configurar alerta por uso de almacenamiento
gcloud alpha monitoring policies create --policy-from-file=bucket-monitoring.yaml
```

## 🔄 Mantenimiento

### Tareas Periódicas

- **Mensual**: Revisar versiones acumuladas del estado
- **Trimestral**: Verificar lifecycle rules
- **Anual**: Auditar permisos y accesos

### Actualizaciones

```bash
# Actualizar configuración del bucket
terraform plan
terraform apply

# Verificar cambios
terraform show
```

## Recursos Útiles
- [Terraform GCS Backend Documentation](https://developer.hashicorp.com/terraform/language/settings/backends/gcs)
- [GCS Pricing Calculator](https://cloud.google.com/products/calculator)
- [GCS Best Practices](https://cloud.google.com/storage/docs/best-practices)

---

**Última actualización**: Mayo 2025
**Versión**: 2.0  
**Mantenido por**: EstebanGZam