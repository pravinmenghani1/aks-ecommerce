#!/bin/bash

# Diagnostic script for e-commerce application

EXTERNAL_IP="132.196.131.226"
NAMESPACE="ecommerce"

echo "🔍 Diagnosing E-commerce Application"
echo "===================================="
echo ""

echo "1. Testing Frontend Access:"
echo "----------------------------"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" http://$EXTERNAL_IP/

echo ""
echo "2. Testing API Endpoints:"
echo "-------------------------"

# Test products endpoint
echo "📱 Products endpoint:"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" http://$EXTERNAL_IP/api/products

# Test featured products
echo "⭐ Featured products:"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" http://$EXTERNAL_IP/api/featured

# Test categories
echo "📂 Categories:"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" http://$EXTERNAL_IP/api/categories

# Test health (direct backend)
echo "❤️  Health check (backend direct):"
kubectl exec deployment/backend-deployment -n $NAMESPACE -- wget -qO- http://localhost:3000/health

echo ""
echo "3. Testing API Response Content:"
echo "--------------------------------"
echo "Sample products (first 200 chars):"
curl -s http://$EXTERNAL_IP/api/products | head -c 200
echo "..."

echo ""
echo ""
echo "4. Pod Status:"
echo "--------------"
kubectl get pods -n $NAMESPACE

echo ""
echo "5. Service Status:"
echo "------------------"
kubectl get services -n $NAMESPACE

echo ""
echo "6. Ingress Status:"
echo "------------------"
kubectl get ingress -n $NAMESPACE

echo ""
echo "🎯 Quick Access URLs:"
echo "====================="
echo "Frontend: http://$EXTERNAL_IP"
echo "API: http://$EXTERNAL_IP/api/products"
echo "Featured: http://$EXTERNAL_IP/api/featured"
echo ""
echo "💡 If products aren't loading in the browser:"
echo "   1. Open browser developer tools (F12)"
echo "   2. Check Console tab for JavaScript errors"
echo "   3. Check Network tab to see if API calls are failing"
