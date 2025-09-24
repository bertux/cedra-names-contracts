#!/bin/bash

# Cedra Names Service - Domain Registration Script
# This script sets up affordable domain pricing and registers a domain

set -e

echo "🌐 Cedra Names Service - Domain Registration"
echo "=============================================="

# Configuration
ACCOUNT="0x96721e0bb121896eb440f5ec7e78615cd35262c8c9caa9a6d1d4b1f2c2f35197"
DOMAIN_NAME="${1:-myverylongdomainname}"
REGISTRATION_YEARS="${2:-1}"

echo "📋 Configuration:"
echo "  Account: $ACCOUNT"
echo "  Domain: $DOMAIN_NAME"
echo "  Years: $REGISTRATION_YEARS"
echo ""

# Step 1: Set affordable pricing for 6+ character domains (0.001 CEDRA)
echo "💰 Setting domain pricing for 6+ character domains to 0.001 CEDRA..."
cedra move run \
  --function-id "$ACCOUNT::config::set_domain_price_for_length" \
  --args u64:100000 u64:6 \
  --profile default

echo "✅ Domain pricing updated successfully"
echo ""

# Step 2: Initialize reverse lookup registry (if not already done)
echo "🔗 Initializing reverse lookup registry..."
cedra move run \
  --function-id "$ACCOUNT::domains::init_reverse_lookup_registry_v1" \
  --args \
  --profile default

echo "✅ Reverse lookup registry initialized"
echo ""

# Step 3: Register the domain
echo "📝 Registering domain: $DOMAIN_NAME"
cedra move run \
  --function-id "$ACCOUNT::domains::register_domain" \
  --args string:"$DOMAIN_NAME" u8:$REGISTRATION_YEARS \
  --profile default

echo "✅ Domain '$DOMAIN_NAME' registered successfully!"
echo ""

# Step 4: Verify registration
echo "🔍 Verifying domain registration..."
cedra account list --profile default | grep -A 10 -B 10 "cedra_names"

echo ""
echo "🎉 Domain registration complete!"
echo "   Domain: $DOMAIN_NAME"
echo "   Duration: $REGISTRATION_YEARS year(s)"
echo "   Account: $ACCOUNT"
echo ""
echo "💡 To register additional domains, run:"
echo "   ./sh_scripts/move_register_domain.sh <domain_name> [years]"
echo ""
echo "📚 Available functions:"
echo "   - Register domain: $ACCOUNT::domains::register_domain"
echo "   - Register subdomain: $ACCOUNT::domains::register_subdomain"
echo "   - Set name address: $ACCOUNT::domains::set_name_address"
echo "   - Set reverse lookup: $ACCOUNT::domains::set_reverse_lookup"
