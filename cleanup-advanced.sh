#!/bin/bash

# Advanced cleanup script with options

set -e

RESOURCE_GROUP="myaks1_group"
CLUSTER_NAME="myaks1"
NAMESPACE="ecommerce"

echo "🧹 Advanced Cleanup Options for E-commerce Deployment"
echo "====================================================="
echo ""
echo "Choose what to delete:"
echo "1. Delete only e-commerce application (keep ingress controller)"
echo "2. Delete ingress controller only (keep e-commerce app)"
echo "3. Delete everything (e-commerce app + ingress controller)"
echo "4. Delete specific deployments only"
echo "5. Delete persistent volumes only"
echo "6. Exit without deleting anything"
echo ""
read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        echo "🗑️  Deleting e-commerce application..."
        kubectl delete namespace $NAMESPACE --ignore-not-found=true
        echo "✅ E-commerce application deleted!"
        ;;
    2)
        echo "🗑️  Deleting NGINX ingress controller..."
        kubectl delete namespace ingress-nginx --ignore-not-found=true
        echo "✅ Ingress controller deleted!"
        ;;
    3)
        echo "🗑️  Deleting everything..."
        kubectl delete namespace $NAMESPACE --ignore-not-found=true
        kubectl delete namespace ingress-nginx --ignore-not-found=true
        echo "✅ Everything deleted!"
        ;;
    4)
        echo "🗑️  Deleting specific deployments..."
        echo "Available deployments:"
        kubectl get deployments -n $NAMESPACE 2>/dev/null || echo "No deployments found"
        echo ""
        read -p "Enter deployment name to delete (or 'all' for all): " deployment
        if [ "$deployment" = "all" ]; then
            kubectl delete deployments --all -n $NAMESPACE
        else
            kubectl delete deployment $deployment -n $NAMESPACE
        fi
        echo "✅ Deployments deleted!"
        ;;
    5)
        echo "🗑️  Deleting persistent volumes..."
        kubectl delete pvc --all -n $NAMESPACE
        echo "✅ Persistent volumes deleted!"
        ;;
    6)
        echo "❌ Cleanup cancelled."
        exit 0
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "📋 Current cluster status:"
echo "========================="
kubectl get namespaces | grep -E "(ecommerce|ingress-nginx)" || echo "No e-commerce or ingress namespaces found"
echo ""
kubectl get pods --all-namespaces | grep -E "(ecommerce|ingress-nginx)" || echo "No e-commerce or ingress pods found"
