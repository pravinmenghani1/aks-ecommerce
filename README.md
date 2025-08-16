# E-commerce Multi-Container Deployment on AKS

This repository contains scripts and Kubernetes manifests to deploy a multi-container e-commerce application on Azure Kubernetes Service (AKS).

## 🏗️ Architecture

The deployment includes:
- **Frontend**: Nginx-based web server with responsive React-style interface
- **Backend**: Node.js API server with product catalog and authentication
- **Database**: PostgreSQL with persistent storage
- **Cache**: Redis for session management and caching
- **Ingress**: NGINX ingress controller for external access

## 📱 Product Catalog

Your e-commerce store includes:
- iPhone 15 Pro ($999.99) ⭐ Featured
- MacBook Pro 16-inch ($2,499.99) ⭐ Featured
- Studio Display 27-inch ($1,599.99)
- Pro Display XDR ($4,999.99) ⭐ Featured
- 4K Smart Projector ($899.99)
- Home Theater Projector ($2,299.99) ⭐ Featured

## 🔧 Prerequisites

- Azure CLI installed and configured
- kubectl installed
- Access to AKS cluster
- Helm (optional, for monitoring setup)

## 🚀 Quick Start

### 1. **Clone and Setup**
```bash
git clone https://github.com/pravinmenghani1/aks-ecommerce.git
cd aks-ecommerce
chmod +x *.sh
```

### 2. **Configure Secrets (IMPORTANT)**
```bash
# Setup your credentials securely
./setup-secrets.sh
```

### 3. **Verify Cluster Connectivity**
```bash
./verify-cluster.sh
```

### 4. **Deploy Application**
```bash
# Setup ingress controller (first time only)
./setup-ingress.sh

# Deploy e-commerce application
./deploy-ecommerce.sh

# Verify deployment and get access URL
./verify-deployment.sh

# Optional: Setup monitoring
./setup-monitoring.sh
```

## 🔐 Security Features

- **No credentials in git**: All sensitive data is excluded via `.gitignore`
- **Template-based secrets**: Use `setup-secrets.sh` to create secure configurations
- **CORS enabled**: Proper API security headers
- **Health checks**: Liveness and readiness probes
- **Resource limits**: CPU and memory constraints

## 🌐 API Endpoints

Once deployed, your application provides:
- `GET /api/products` - All products with specifications
- `GET /api/products/:id` - Single product details
- `GET /api/categories` - Product categories
- `GET /api/products/category/:category` - Products by category
- `GET /api/featured` - Featured products only
- `GET /health` - Backend health check

## 📁 File Structure

```
aks-ecommerce/
├── deploy-ecommerce.sh      # Main deployment script
├── setup-ingress.sh         # Ingress controller setup
├── setup-monitoring.sh      # Optional monitoring setup
├── setup-secrets.sh         # Secure secrets configuration
├── verify-cluster.sh        # Cluster connectivity verification
├── verify-deployment.sh     # Deployment verification
├── cleanup.sh               # Quick cleanup script
├── cleanup-advanced.sh      # Advanced cleanup options
├── test-api.sh             # API testing script
├── diagnose-app.sh         # Troubleshooting script
├── port-forward.sh         # Local development access
├── TROUBLESHOOTING.md      # Comprehensive troubleshooting guide
└── k8s/
    ├── configmap.yaml      # Application configuration
    ├── secrets-template.yaml # Secrets template (no real credentials)
    ├── product-data.yaml   # Product catalog data
    ├── product-images.yaml # Product images (base64 encoded)
    ├── ingress.yaml        # Ingress configuration
    ├── ingress-production.yaml # Production ingress template
    ├── database/
    │   ├── postgres-deployment.yaml
    │   └── postgres-pvc.yaml
    ├── redis/
    │   └── redis-deployment.yaml
    ├── backend/
    │   └── backend-deployment.yaml
    └── frontend/
        └── frontend-deployment.yaml
```

## 🎯 Accessing the Application

After deployment, get your external IP:
```bash
./verify-deployment.sh
```

Then access:
- **Frontend**: `http://<EXTERNAL-IP>`
- **API**: `http://<EXTERNAL-IP>/api/products`

For local testing, add to `/etc/hosts`:
```
<EXTERNAL-IP> ecommerce.local
```

## 📊 Monitoring Commands

```bash
# View all pods
kubectl get pods -n ecommerce

# Check pod logs
kubectl logs -f deployment/backend-deployment -n ecommerce

# Monitor resource usage
kubectl top pods -n ecommerce

# Check events
kubectl get events -n ecommerce --sort-by='.lastTimestamp'
```

## 🔄 Scaling

```bash
# Scale backend
kubectl scale deployment backend-deployment --replicas=5 -n ecommerce

# Scale frontend
kubectl scale deployment frontend-deployment --replicas=3 -n ecommerce
```

## 🔄 Updates

```bash
# Update backend image
kubectl set image deployment/backend-deployment backend=your-registry/backend:v2 -n ecommerce

# Update frontend image
kubectl set image deployment/frontend-deployment frontend=your-registry/frontend:v2 -n ecommerce
```

## 🧹 Cleanup

```bash
# Quick cleanup (e-commerce app only)
./cleanup.sh

# Advanced cleanup with options
./cleanup-advanced.sh

# Complete cleanup (including ingress controller)
kubectl delete namespace ecommerce
kubectl delete namespace ingress-nginx
```

## 🔧 Troubleshooting

If you encounter issues:

1. **Products not loading**: Check `TROUBLESHOOTING.md`
2. **404 errors**: Verify ingress configuration
3. **Pod failures**: Check logs with `kubectl logs`
4. **API issues**: Test with `./test-api.sh`

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for comprehensive troubleshooting guide.

## 🛡️ Security Considerations

1. **Secrets Management**: 
   - Never commit `k8s/secrets.yaml` to git
   - Use Azure Key Vault for production
   - Rotate credentials regularly

2. **Network Security**: 
   - Implement network policies
   - Use HTTPS with proper certificates
   - Configure RBAC properly

3. **Image Security**: 
   - Use trusted base images
   - Scan for vulnerabilities
   - Keep images updated

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Review AKS documentation
- Use kubectl commands for debugging

---

**⚠️ Important**: Always run `./setup-secrets.sh` before deployment to configure your credentials securely!
