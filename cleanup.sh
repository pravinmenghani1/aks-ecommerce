#!/bin/bash

# Cleanup script for e-commerce deployment

set -e

RESOURCE_GROUP="myaks1-group"
CLUSTER_NAME="myaks1"
NAMESPACE="ecommerce"

echo "🧹 Cleaning up e-commerce deployment..."

# Connect to AKS cluster
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

# Confirm deletion
echo "⚠️  This will delete all resources in the '$NAMESPACE' namespace."
echo "Are you sure you want to continue? (y/n)"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "🗑️  Deleting namespace and all resources..."
    kubectl delete namespace $NAMESPACE --ignore-not-found=true
    
    echo "✅ Cleanup complete!"
    echo "📝 The following resources have been removed:"
    echo "   - All deployments in $NAMESPACE namespace"
    echo "   - All services in $NAMESPACE namespace"
    echo "   - All persistent volume claims in $NAMESPACE namespace"
    echo "   - All configmaps and secrets in $NAMESPACE namespace"
else
    echo "❌ Cleanup cancelled."
fi
