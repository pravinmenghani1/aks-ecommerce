#!/bin/bash

# Script to setup secrets.yaml from template
# This ensures no credentials are committed to git

set -e

SECRETS_FILE="k8s/secrets.yaml"
TEMPLATE_FILE="k8s/secrets-template.yaml"

echo "🔐 Setting up Kubernetes secrets..."
echo ""

if [ -f "$SECRETS_FILE" ]; then
    echo "⚠️  secrets.yaml already exists. Do you want to overwrite it? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Setup cancelled."
        exit 0
    fi
fi

echo "📝 Please provide the following credentials:"
echo ""

# Database credentials
read -p "Database username (default: postgres): " db_username
db_username=${db_username:-postgres}

read -s -p "Database password: " db_password
echo ""

# JWT Secret
read -s -p "JWT secret key (for authentication): " jwt_secret
echo ""

# Stripe API key (optional)
read -p "Stripe secret key (optional, press enter to skip): " stripe_key

# Email credentials (optional)
read -p "SMTP username/email (optional, press enter to skip): " smtp_username
if [ ! -z "$smtp_username" ]; then
    read -s -p "SMTP password: " smtp_password
    echo ""
fi

# Redis password (optional)
read -s -p "Redis password (optional, press enter to use default): " redis_password
redis_password=${redis_password:-redispassword}
echo ""

echo ""
echo "🔄 Encoding credentials and creating secrets.yaml..."

# Encode values to base64
DB_USERNAME_B64=$(echo -n "$db_username" | base64)
DB_PASSWORD_B64=$(echo -n "$db_password" | base64)
JWT_SECRET_B64=$(echo -n "$jwt_secret" | base64)
STRIPE_KEY_B64=$(echo -n "${stripe_key:-sk_test_placeholder}" | base64)
SMTP_USERNAME_B64=$(echo -n "${smtp_username:-placeholder@example.com}" | base64)
SMTP_PASSWORD_B64=$(echo -n "${smtp_password:-placeholder}" | base64)
REDIS_PASSWORD_B64=$(echo -n "$redis_password" | base64)

# Create secrets.yaml from template
cat > "$SECRETS_FILE" << EOF
apiVersion: v1
kind: Secret
metadata:
  name: ecommerce-secrets
  namespace: ecommerce
type: Opaque
data:
  # Database credentials
  DB_USERNAME: $DB_USERNAME_B64
  DB_PASSWORD: $DB_PASSWORD_B64
  
  # JWT secret for authentication
  JWT_SECRET: $JWT_SECRET_B64
  
  # Payment gateway API key
  STRIPE_SECRET_KEY: $STRIPE_KEY_B64
  
  # Email credentials
  SMTP_USERNAME: $SMTP_USERNAME_B64
  SMTP_PASSWORD: $SMTP_PASSWORD_B64
  
  # Redis password
  REDIS_PASSWORD: $REDIS_PASSWORD_B64
EOF

echo "✅ secrets.yaml created successfully!"
echo ""
echo "⚠️  IMPORTANT SECURITY NOTES:"
echo "   - secrets.yaml is excluded from git (.gitignore)"
echo "   - Never commit actual credentials to version control"
echo "   - Share credentials securely through encrypted channels"
echo "   - Use Azure Key Vault or similar for production deployments"
echo ""
echo "🚀 You can now run: ./deploy-ecommerce.sh"
