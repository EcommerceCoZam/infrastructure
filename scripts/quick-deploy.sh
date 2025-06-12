#!/bin/bash
echo "🚀 Desplegando toda la infraestructura..."

# Shared resources primero
cd shared/gcp-bucket && terraform apply -auto-approve
cd ../gcp-registry && terraform apply -auto-approve

# Environments
cd ../../environments/dev && terraform apply -auto-approve
cd ../stage && terraform apply -auto-approve  
cd ../prod && terraform apply -auto-approve

echo "✅ Infraestructura desplegada"