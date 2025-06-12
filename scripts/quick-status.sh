#!/bin/bash
echo "📊 Estado de la infraestructura:"

# Función para verificar estado (local o remoto)
check_status() {
    local dir=$1
    local name=$2
    
    if [ -d "$dir" ]; then
        cd "$dir"
        
        # Verificar si tiene backend remoto configurado
        if grep -q "backend.*gcs" *.tf 2>/dev/null; then
            # Estado remoto - usar terraform show
            if terraform show -json 2>/dev/null | jq -e '.values.root_module.resources' >/dev/null 2>&1; then
                count=$(terraform show -json 2>/dev/null | jq '.values.root_module.resources | length' 2>/dev/null || echo "0")
                echo "  $name: $count recursos (remoto)"
            else
                echo "  $name: No desplegado (remoto)"
            fi
        else
            # Estado local - verificar archivo tfstate
            if [ -f "terraform.tfstate" ]; then
                count=$(jq '.resources | length' terraform.tfstate 2>/dev/null || echo "0")
                echo "  $name: $count recursos (local)"
            else
                echo "  $name: No desplegado (local)"
            fi
        fi
        
        cd - >/dev/null
    else
        echo "  $name: Directorio no existe"
    fi
}

# Verificar shared resources
echo "🔧 Shared Resources:"
check_status "shared/gcp-bucket" "gcp-bucket"
check_status "shared/gcp-registry" "gcp-registry"

echo ""
echo "🏗️ Environments:"
check_status "environments/dev" "dev"
check_status "environments/stage" "stage" 
check_status "environments/prod" "prod"

echo ""
echo "💡 Para más detalles: cd <directorio> && terraform show"