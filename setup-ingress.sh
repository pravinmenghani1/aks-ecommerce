#!/bin/bash

# Setup NGINX Ingress Controller on AKS
# This script installs the NGINX ingress controller if not already present

set -e

RESOURCE_GROUP="myaks1-group"
CLUSTER_NAME="myaks1"

echo "🔧 Setting up NGINX Ingress Controller..."

# Connect to AKS cluster
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

# Check if ingress controller is already installed
if kubectl get namespace ingress-nginx >/dev/null 2>&1; then
    echo "✅ NGINX Ingress Controller namespace already exists"
else
    echo "📦 Installing NGINX Ingress Controller..."
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
fi

# Wait for ingress controller to be ready
echo "⏳ Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# Get external IP
echo "🌐 Getting external IP address..."
kubectl get service ingress-nginx-controller --namespace=ingress-nginx

echo "✅ NGINX Ingress Controller setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Note the EXTERNAL-IP from the service above"
echo "2. Update your DNS or /etc/hosts file to point your domain to this IP"
echo "3. Run the main deployment script: ./deploy-ecommerce.sh"
