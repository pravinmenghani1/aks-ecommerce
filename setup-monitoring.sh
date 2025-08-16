#!/bin/bash

# Optional: Setup monitoring and logging for the e-commerce application

set -e

RESOURCE_GROUP="myaks1-group"
CLUSTER_NAME="myaks1"
NAMESPACE="ecommerce"

echo "📊 Setting up monitoring and logging..."

# Connect to AKS cluster
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

# Enable Azure Monitor for containers (if not already enabled)
echo "🔍 Enabling Azure Monitor for containers..."
az aks enable-addons --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --addons monitoring

# Create monitoring namespace
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Deploy Prometheus and Grafana (optional)
echo "📈 Would you like to install Prometheus and Grafana? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Add Prometheus Helm repo
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    
    # Install Prometheus
    helm install prometheus prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --set grafana.adminPassword=admin123 \
        --set grafana.service.type=LoadBalancer
    
    echo "✅ Prometheus and Grafana installed!"
    echo "📝 Grafana credentials: admin/admin123"
    echo "🌐 Get Grafana external IP: kubectl get svc -n monitoring prometheus-grafana"
fi

echo "✅ Monitoring setup complete!"
echo ""
echo "📝 Useful monitoring commands:"
echo "   - View logs: kubectl logs -f deployment/<deployment-name> -n $NAMESPACE"
echo "   - Monitor resources: kubectl top pods -n $NAMESPACE"
echo "   - Check events: kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp'"
