#!/bin/bash

# Enhanced verification script after deployment

echo "🔍 Verifying E-commerce Deployment"
echo "=================================="
echo ""

# Check if all pods are running
echo "1. Pod Status:"
kubectl get pods -n ecommerce

echo ""
echo "2. Service Status:"
kubectl get services -n ecommerce

echo ""
echo "3. Ingress Status:"
kubectl get ingress -n ecommerce

echo ""
echo "4. External Access:"

# Get external IP from ingress controller
EXTERNAL_IP=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)

if [ -z "$EXTERNAL_IP" ] || [ "$EXTERNAL_IP" = "null" ]; then
    echo "⚠️  External IP not yet assigned. Checking ingress..."
    EXTERNAL_IP=$(kubectl get ingress -n ecommerce -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}' 2>/dev/null)
fi

if [ -z "$EXTERNAL_IP" ] || [ "$EXTERNAL_IP" = "null" ]; then
    echo "⏳ External IP still being assigned. Please wait a few minutes and run this script again."
    echo "   You can check status with: kubectl get service ingress-nginx-controller -n ingress-nginx"
    exit 1
fi

echo "External IP: $EXTERNAL_IP"
echo ""
echo "🌐 Access URLs:"
echo "   Frontend: http://$EXTERNAL_IP"
echo "   API: http://$EXTERNAL_IP/api/products"
echo "   Featured Products: http://$EXTERNAL_IP/api/featured"
echo "   Categories: http://$EXTERNAL_IP/api/categories"
echo ""

# Test API endpoints
echo "5. API Health Tests:"
echo "==================="

# Test frontend
echo -n "Frontend: "
if curl -s -o /dev/null -w "%{http_code}" http://$EXTERNAL_IP/ | grep -q "200"; then
    echo "✅ Working (Status: 200)"
else
    echo "❌ Failed"
fi

# Test API products
echo -n "Products API: "
if curl -s -o /dev/null -w "%{http_code}" http://$EXTERNAL_IP/api/products | grep -q "200"; then
    echo "✅ Working (Status: 200)"
else
    echo "❌ Failed"
fi

# Test API featured
echo -n "Featured API: "
if curl -s -o /dev/null -w "%{http_code}" http://$EXTERNAL_IP/api/featured | grep -q "200"; then
    echo "✅ Working (Status: 200)"
else
    echo "❌ Failed"
fi

# Test API categories
echo -n "Categories API: "
if curl -s -o /dev/null -w "%{http_code}" http://$EXTERNAL_IP/api/categories | grep -q "200"; then
    echo "✅ Working (Status: 200)"
else
    echo "❌ Failed"
fi

echo ""
echo "6. Sample Product Data:"
echo "======================"
echo "First product from API:"
curl -s http://$EXTERNAL_IP/api/products | head -c 300 | grep -o '"name":"[^"]*"' | head -1 | sed 's/"name":"//;s/"//' || echo "Unable to fetch product data"

echo ""
echo ""
echo "✅ Deployment verification complete!"
echo ""
echo "📱 Your e-commerce store includes:"
echo "   • iPhone 15 Pro ($999.99) ⭐ Featured"
echo "   • MacBook Pro 16-inch ($2,499.99) ⭐ Featured"
echo "   • Studio Display & Pro Display XDR"
echo "   • 4K Smart Projector & Home Theater Projector"
echo ""
echo "🎯 Quick Access:"
echo "   Open in browser: http://$EXTERNAL_IP"
echo ""
echo "🔧 Troubleshooting:"
echo "   If products don't load, check browser console (F12) for errors"
echo "   API direct test: curl http://$EXTERNAL_IP/api/products"
