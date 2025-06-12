#!/bin/bash
echo "💥 Destruyendo toda la infraestructura..."

# Environments primero (orden inverso)
cd environments/prod && terraform destroy -auto-approve
cd ../stage && terraform destroy -auto-approve
cd ../dev && terraform destroy -auto-approve

# Shared resources al final
cd ../../shared/gcp-registry && terraform destroy -auto-approve
cd ../gcp-bucket && terraform destroy -auto-approve

echo "✅ Infraestructura destruida"
