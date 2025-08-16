#!/bin/bash

# Port forwarding script for local development access

NAMESPACE="ecommerce"

echo "🔗 Setting up port forwarding for e-commerce application..."
echo "This will allow you to access the app locally on your machine"
echo ""

# Kill any existing port forwards
pkill -f "kubectl port-forward" 2>/dev/null || true

echo "📡 Starting port forwards..."

# Frontend port forward
kubectl port-forward svc/frontend-service 8080:80 -n $NAMESPACE &
FRONTEND_PID=$!

# Backend port forward  
kubectl port-forward svc/backend-service 3000:3000 -n $NAMESPACE &
BACKEND_PID=$!

# Wait a moment for port forwards to establish
sleep 3

echo "✅ Port forwarding active!"
echo ""
echo "🌐 Access your e-commerce application:"
echo "   Frontend: http://localhost:8080"
echo "   Backend API: http://localhost:3000/api/products"
echo ""
echo "📝 API Endpoints:"
echo "   http://localhost:3000/api/products - All products"
echo "   http://localhost:3000/api/featured - Featured products"
echo "   http://localhost:3000/api/categories - Categories"
echo "   http://localhost:3000/health - Health check"
echo ""
echo "⚠️  Press Ctrl+C to stop port forwarding"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🧹 Cleaning up port forwards..."
    kill $FRONTEND_PID $BACKEND_PID 2>/dev/null || true
    pkill -f "kubectl port-forward" 2>/dev/null || true
    echo "✅ Port forwarding stopped"
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Keep script running
wait
