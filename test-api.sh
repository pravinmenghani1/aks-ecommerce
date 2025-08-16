#!/bin/bash

# Test script for e-commerce API endpoints

NAMESPACE="ecommerce"

echo "🧪 Testing E-commerce API Endpoints"
echo "=================================="

# Check if backend service is running
echo "📡 Checking backend service status..."
kubectl get pods -l app=backend -n $NAMESPACE

# Port forward to access the API locally
echo "🔗 Setting up port forwarding..."
kubectl port-forward svc/backend-service 3000:3000 -n $NAMESPACE &
PORT_FORWARD_PID=$!

# Wait for port forward to be ready
sleep 5

echo "🧪 Testing API endpoints..."

# Test health endpoint
echo "1. Testing health endpoint:"
curl -s http://localhost:3000/health | jq '.' || echo "Health check failed"
echo ""

# Test all products
echo "2. Testing all products endpoint:"
curl -s http://localhost:3000/api/products | jq '.products[] | {id, name, price, category}' || echo "Products endpoint failed"
echo ""

# Test categories
echo "3. Testing categories endpoint:"
curl -s http://localhost:3000/api/categories | jq '.' || echo "Categories endpoint failed"
echo ""

# Test featured products
echo "4. Testing featured products:"
curl -s http://localhost:3000/api/featured | jq '.products[] | {name, price, featured}' || echo "Featured products failed"
echo ""

# Test specific product
echo "5. Testing specific product (iPhone):"
curl -s http://localhost:3000/api/products/1 | jq '.' || echo "Single product failed"
echo ""

# Test products by category
echo "6. Testing products by category (smartphones):"
curl -s http://localhost:3000/api/products/category/smartphones | jq '.products[] | {name, price}' || echo "Category filter failed"
echo ""

# Clean up port forward
kill $PORT_FORWARD_PID 2>/dev/null

echo "✅ API testing completed!"
echo ""
echo "💡 To manually test:"
echo "   kubectl port-forward svc/backend-service 3000:3000 -n $NAMESPACE"
echo "   Then visit: http://localhost:3000/api/products"
