#!/bin/bash

# Verification script for AKS cluster connectivity
# Resource Group: myaks1-group, Cluster: myaks1

set -e

RESOURCE_GROUP="myaks1-group"
CLUSTER_NAME="myaks1"

echo "🔍 Verifying AKS cluster connectivity..."
echo "Resource Group: $RESOURCE_GROUP"
echo "Cluster Name: $CLUSTER_NAME"
echo ""

# Check if Azure CLI is logged in
echo "1. Checking Azure CLI authentication..."
if az account show >/dev/null 2>&1; then
    echo "✅ Azure CLI is authenticated"
    SUBSCRIPTION=$(az account show --query name -o tsv)
    echo "   Current subscription: $SUBSCRIPTION"
else
    echo "❌ Azure CLI not authenticated. Please run: az login"
    exit 1
fi

echo ""

# Check if resource group exists
echo "2. Checking resource group..."
if az group show --name $RESOURCE_GROUP >/dev/null 2>&1; then
    echo "✅ Resource group '$RESOURCE_GROUP' exists"
    LOCATION=$(az group show --name $RESOURCE_GROUP --query location -o tsv)
    echo "   Location: $LOCATION"
else
    echo "❌ Resource group '$RESOURCE_GROUP' not found"
    echo "   Available resource groups:"
    az group list --query "[].name" -o table
    exit 1
fi

echo ""

# Check if AKS cluster exists
echo "3. Checking AKS cluster..."
if az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME >/dev/null 2>&1; then
    echo "✅ AKS cluster '$CLUSTER_NAME' exists"
    
    # Get cluster info
    CLUSTER_STATUS=$(az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --query provisioningState -o tsv)
    KUBERNETES_VERSION=$(az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --query kubernetesVersion -o tsv)
    NODE_COUNT=$(az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --query agentPoolProfiles[0].count -o tsv)
    
    echo "   Status: $CLUSTER_STATUS"
    echo "   Kubernetes Version: $KUBERNETES_VERSION"
    echo "   Node Count: $NODE_COUNT"
else
    echo "❌ AKS cluster '$CLUSTER_NAME' not found in resource group '$RESOURCE_GROUP'"
    echo "   Available AKS clusters in this resource group:"
    az aks list --resource-group $RESOURCE_GROUP --query "[].name" -o table 2>/dev/null || echo "   No AKS clusters found"
    exit 1
fi

echo ""

# Test kubectl connectivity
echo "4. Testing kubectl connectivity..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing >/dev/null 2>&1

if kubectl cluster-info >/dev/null 2>&1; then
    echo "✅ kubectl connectivity successful"
    
    # Get cluster info
    KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null | grep "Client Version" || echo "kubectl version info unavailable")
    NODE_STATUS=$(kubectl get nodes --no-headers 2>/dev/null | wc -l || echo "0")
    
    echo "   $KUBECTL_VERSION"
    echo "   Connected nodes: $NODE_STATUS"
    
    # Show node status
    echo ""
    echo "   Node status:"
    kubectl get nodes -o wide 2>/dev/null || echo "   Unable to get node status"
else
    echo "❌ kubectl connectivity failed"
    echo "   Please check your cluster status and network connectivity"
    exit 1
fi

echo ""
echo "🎉 All checks passed! Your AKS cluster is ready for deployment."
echo ""
echo "📝 Next steps:"
echo "   1. Setup ingress controller: ./setup-ingress.sh"
echo "   2. Deploy e-commerce application: ./deploy-ecommerce.sh"
echo "   3. Optional monitoring setup: ./setup-monitoring.sh"
