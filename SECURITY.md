# Security Guidelines

## 🔐 Credentials Management

### ✅ What's Safe in Git
- `secrets-template.yaml` - Template with placeholders only
- All deployment scripts and configurations
- Documentation and troubleshooting guides

### ❌ What's NEVER in Git
- `k8s/secrets.yaml` - Contains actual base64 encoded credentials
- `.env` files with environment variables
- Any files with real passwords, API keys, or tokens
- Personal kubeconfig files

## 🛡️ Security Features Implemented

### 1. **Git Security**
- `.gitignore` excludes all sensitive files
- `secrets-template.yaml` contains only placeholders
- No real credentials committed to repository

### 2. **Kubernetes Security**
- Secrets stored as Kubernetes Secret objects
- Base64 encoding for credential storage
- Namespace isolation (`ecommerce` namespace)
- Resource limits and health checks

### 3. **Network Security**
- CORS enabled for API endpoints
- Ingress controller with proper routing
- SSL/TLS ready configuration (production template)

## 🔧 Setup Process

### For New Users:
1. Clone the repository
2. Run `./setup-secrets.sh` to create credentials
3. Deploy using the provided scripts

### For Production:
1. Use Azure Key Vault for credential storage
2. Implement proper RBAC policies
3. Enable SSL/TLS certificates
4. Set up monitoring and alerting

## 🚨 Security Checklist

Before deployment, ensure:
- [ ] `./setup-secrets.sh` has been run
- [ ] `k8s/secrets.yaml` exists and contains your credentials
- [ ] `k8s/secrets.yaml` is NOT committed to git
- [ ] All scripts have proper permissions (`chmod +x`)
- [ ] AKS cluster has appropriate RBAC configured

## 🔄 Credential Rotation

To rotate credentials:
1. Update values in `k8s/secrets.yaml`
2. Apply changes: `kubectl apply -f k8s/secrets.yaml -n ecommerce`
3. Restart affected pods: `kubectl rollout restart deployment/backend-deployment -n ecommerce`

## 📞 Security Issues

If you discover a security vulnerability:
1. Do NOT create a public issue
2. Contact the repository maintainer directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before disclosure

## 🎯 Best Practices

1. **Never commit real credentials to version control**
2. **Use strong, unique passwords for all services**
3. **Regularly rotate API keys and passwords**
4. **Monitor access logs and unusual activity**
5. **Keep all components updated to latest versions**
6. **Use HTTPS in production environments**
7. **Implement proper backup and disaster recovery**

---

**Remember**: Security is everyone's responsibility. When in doubt, ask!
