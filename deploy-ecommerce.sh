#!/bin/bash

# E-commerce Multi-Container Deployment Script for AKS
# Cluster: myaks1, Resource Group: myaks1-group

set -e

# Configuration
RESOURCE_GROUP="myaks1-group"
CLUSTER_NAME="myaks1"
NAMESPACE="ecommerce"

echo "🚀 Starting e-commerce deployment on AKS cluster: $CLUSTER_NAME"

# Step 1: Connect to AKS cluster
echo "📡 Connecting to AKS cluster..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

# Step 2: Create namespace
echo "📁 Creating namespace: $NAMESPACE"
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Step 3: Apply ConfigMaps and Secrets
echo "⚙️  Applying configuration files..."
kubectl apply -f k8s/configmap.yaml -n $NAMESPACE
kubectl apply -f k8s/secrets.yaml -n $NAMESPACE

# Step 4: Apply product data and images
echo "📦 Loading product catalog..."
kubectl apply -f k8s/product-data.yaml -n $NAMESPACE
kubectl apply -f k8s/product-images.yaml -n $NAMESPACE

# Step 5: Deploy database
echo "🗄️  Deploying database..."
kubectl apply -f k8s/database/ -n $NAMESPACE

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres --timeout=300s -n $NAMESPACE

# Step 6: Deploy Redis cache
echo "🔄 Deploying Redis cache..."
kubectl apply -f k8s/redis/ -n $NAMESPACE

# Wait for Redis to be ready
echo "⏳ Waiting for Redis to be ready..."
kubectl wait --for=condition=ready pod -l app=redis --timeout=300s -n $NAMESPACE

# Step 7: Deploy backend services
echo "🔧 Deploying backend services..."
kubectl apply -f k8s/backend/ -n $NAMESPACE

# Step 8: Deploy frontend
echo "🎨 Deploying frontend..."
kubectl apply -f k8s/frontend/ -n $NAMESPACE

# Step 9: Apply ingress (supports both domain and IP access)
echo "🌐 Setting up ingress..."
kubectl apply -f k8s/ingress.yaml -n $NAMESPACE

# Step 10: Wait for all deployments to be ready
echo "⏳ Waiting for all deployments to be ready..."
kubectl wait --for=condition=available deployment --all --timeout=600s -n $NAMESPACE

# Step 11: Get service information
echo "📋 Deployment Summary:"
echo "===================="
kubectl get pods -n $NAMESPACE
echo ""
kubectl get services -n $NAMESPACE
echo ""
kubectl get ingress -n $NAMESPACE

# Get external IP
echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📱 Your e-commerce store includes:"
echo "   ✅ iPhone 15 Pro - Premium smartphone"
echo "   ✅ MacBook Pro 16-inch - Professional laptop"
echo "   ✅ Studio Display & Pro Display XDR - High-end monitors"
echo "   ✅ 4K Smart Projector & Home Theater Projector"
echo ""
echo "🌐 API Endpoints available:"
echo "   - GET /api/products - All products"
echo "   - GET /api/products/:id - Single product"
echo "   - GET /api/categories - Product categories"
echo "   - GET /api/products/category/:category - Products by category"
echo "   - GET /api/featured - Featured products"
echo ""
echo "📝 To access your e-commerce application:"
echo "   - Check ingress external IP: kubectl get ingress -n $NAMESPACE"
echo "   - Monitor pods: kubectl get pods -n $NAMESPACE -w"
echo "   - View backend logs: kubectl logs -f deployment/backend-deployment -n $NAMESPACE"
echo "   - View frontend logs: kubectl logs -f deployment/frontend-deployment -n $NAMESPACE"

echo ""
echo "🔍 Useful commands:"
echo "   - Scale deployment: kubectl scale deployment <name> --replicas=3 -n $NAMESPACE"
echo "   - Update image: kubectl set image deployment/<name> <container>=<new-image> -n $NAMESPACE"
echo "   - Delete deployment: kubectl delete namespace $NAMESPACE"
echo ""
echo "💡 Test the API directly:"
echo "   kubectl port-forward svc/backend-service 3000:3000 -n $NAMESPACE"
echo "   Then visit: http://localhost:3000/api/products"
