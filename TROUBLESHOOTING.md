# E-commerce Application Troubleshooting Guide

## 🔧 Issues Fixed in Scripts

### **Issue 1: 404 Not Found when accessing via IP**
**Problem**: Ingress only configured for `ecommerce.local` host, not for direct IP access.

**Root Cause**: Original ingress configuration only had:
```yaml
rules:
- host: ecommerce.local  # Only accepts requests to this specific host
```

**Fix Applied**: Updated `k8s/ingress.yaml` to accept both domain and IP access:
```yaml
rules:
- host: ecommerce.local    # Domain-based access
  http: # ... paths
- http:                    # IP-based access (no host = accepts any host/IP)
  paths: # ... same paths
```

### **Issue 2: Backend Pod CrashLoopBackOff**
**Problem**: `/app` directory didn't exist in container.

**Fix Applied**: Updated backend deployment to create directory first:
```bash
mkdir -p /app
cat > /app/server.js << 'EOF'
```

### **Issue 3: API Path Rewriting Issues**
**Problem**: `nginx.ingress.kubernetes.io/rewrite-target: /` was causing API path conflicts.

**Fix Applied**: Removed problematic rewrite rules and used proper path routing.

## 🚀 Enhanced Scripts

### **1. Robust Ingress Configuration**
- ✅ Supports both IP and domain access
- ✅ Proper CORS headers for API calls
- ✅ Modern `ingressClassName: nginx`
- ✅ Static asset caching

### **2. Enhanced Verification Script**
- ✅ Automatically detects external IP
- ✅ Tests all API endpoints
- ✅ Shows actual access URLs
- ✅ Provides troubleshooting guidance

### **3. Improved Deployment Flow**
- ✅ Single ingress configuration (no conflicts)
- ✅ Better error handling
- ✅ Comprehensive health checks

## 🎯 Deployment Commands (Fixed)

```bash
# 1. Setup ingress controller
./setup-ingress.sh

# 2. Deploy e-commerce application  
./deploy-ecommerce.sh

# 3. Verify deployment and get access URL
./verify-deployment.sh

# 4. Optional: Setup monitoring
./setup-monitoring.sh
```

## 🔍 Common Issues & Solutions

### **Issue**: Products not loading in browser
**Solutions**:
1. Hard refresh browser (Ctrl+F5 / Cmd+Shift+R)
2. Check browser console (F12) for JavaScript errors
3. Test API directly: `curl http://YOUR-IP/api/products`
4. Check ingress: `kubectl get ingress -n ecommerce`

### **Issue**: External IP not assigned
**Solutions**:
1. Wait 2-3 minutes for LoadBalancer provisioning
2. Check: `kubectl get service ingress-nginx-controller -n ingress-nginx`
3. Verify AKS cluster has proper permissions for LoadBalancer

### **Issue**: Pods not starting
**Solutions**:
1. Check pod logs: `kubectl logs -f deployment/DEPLOYMENT-NAME -n ecommerce`
2. Check events: `kubectl get events -n ecommerce --sort-by='.lastTimestamp'`
3. Check resource limits: `kubectl describe pod POD-NAME -n ecommerce`

## 📊 Monitoring Commands

```bash
# Check all resources
kubectl get all -n ecommerce

# Watch pods
kubectl get pods -n ecommerce -w

# Check logs
kubectl logs -f deployment/backend-deployment -n ecommerce
kubectl logs -f deployment/frontend-deployment -n ecommerce

# Check resource usage
kubectl top pods -n ecommerce

# Test API endpoints
curl http://YOUR-IP/api/products
curl http://YOUR-IP/api/featured
curl http://YOUR-IP/api/categories
```

## 🧹 Cleanup Commands

```bash
# Quick cleanup (e-commerce app only)
./cleanup.sh

# Advanced cleanup with options
./cleanup-advanced.sh

# Manual cleanup
kubectl delete namespace ecommerce
kubectl delete namespace ingress-nginx
```

## ✅ Success Indicators

When everything is working correctly, you should see:
- ✅ All pods in `Running` status
- ✅ External IP assigned to ingress controller
- ✅ HTTP 200 responses from all API endpoints
- ✅ Products loading in browser interface
- ✅ No JavaScript errors in browser console

## 🎯 Expected Results

**Frontend**: Modern e-commerce interface with product catalog
**API Endpoints**: 
- `/api/products` - All products with specifications
- `/api/featured` - Featured products only
- `/api/categories` - Product categories
- `/health` - Backend health check

**Products Available**:
- iPhone 15 Pro ($999.99) ⭐ Featured
- MacBook Pro 16-inch ($2,499.99) ⭐ Featured  
- Studio Display 27-inch ($1,599.99)
- Pro Display XDR ($4,999.99) ⭐ Featured
- 4K Smart Projector ($899.99)
- Home Theater Projector ($2,299.99) ⭐ Featured
