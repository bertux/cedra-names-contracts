#!/bin/bash

# Cedra Names Service - Domain Utilities
# Helper functions for domain management

set -e

ACCOUNT="0x96721e0bb121896eb440f5ec7e78615cd35262c8c9caa9a6d1d4b1f2c2f35197"

# Function to register a domain
register_domain() {
    local domain_name="$1"
    local years="${2:-1}"
    
    echo "📝 Registering domain: $domain_name for $years year(s)"
    cedra move run \
        --function-id "$ACCOUNT::domains::register_domain" \
        --args string:"$domain_name" u8:$years \
        --profile default
}

# Function to register a subdomain
register_subdomain() {
    local subdomain_name="$1"
    local domain_name="$2"
    local expiration_time="$3"
    
    echo "📝 Registering subdomain: $subdomain_name.$domain_name"
    cedra move run \
        --function-id "$ACCOUNT::domains::register_subdomain" \
        --args string:"$subdomain_name" string:"$domain_name" u64:$expiration_time \
        --profile default
}

# Function to set name address
set_name_address() {
    local domain_name="$1"
    local target_address="$2"
    
    echo "🎯 Setting name address for $domain_name to $target_address"
    cedra move run \
        --function-id "$ACCOUNT::domains::set_name_address" \
        --args string:"$domain_name" address:$target_address \
        --profile default
}

# Function to set reverse lookup
set_reverse_lookup() {
    local domain_name="$1"
    
    echo "🔄 Setting reverse lookup for $domain_name"
    cedra move run \
        --function-id "$ACCOUNT::domains::set_reverse_lookup" \
        --args string:"$domain_name" \
        --profile default
}

# Function to check domain availability
check_domain() {
    local domain_name="$1"
    
    echo "🔍 Checking domain availability for: $domain_name"
    # This would need to be implemented based on the contract's view functions
    echo "Note: Domain availability checking requires implementing view functions"
}

# Function to get domain info
get_domain_info() {
    local domain_name="$1"
    
    echo "📋 Getting domain information for: $domain_name"
    # This would need to be implemented based on the contract's view functions
    echo "Note: Domain info retrieval requires implementing view functions"
}

# Main script logic
case "$1" in
    "register")
        if [ -z "$2" ]; then
            echo "Usage: $0 register <domain_name> [years]"
            exit 1
        fi
        register_domain "$2" "$3"
        ;;
    "subdomain")
        if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
            echo "Usage: $0 subdomain <subdomain_name> <domain_name> <expiration_time>"
            exit 1
        fi
        register_subdomain "$2" "$3" "$4"
        ;;
    "set-address")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 set-address <domain_name> <target_address>"
            exit 1
        fi
        set_name_address "$2" "$3"
        ;;
    "set-reverse")
        if [ -z "$2" ]; then
            echo "Usage: $0 set-reverse <domain_name>"
            exit 1
        fi
        set_reverse_lookup "$2"
        ;;
    "check")
        if [ -z "$2" ]; then
            echo "Usage: $0 check <domain_name>"
            exit 1
        fi
        check_domain "$2"
        ;;
    "info")
        if [ -z "$2" ]; then
            echo "Usage: $0 info <domain_name>"
            exit 1
        fi
        get_domain_info "$2"
        ;;
    *)
        echo "🌐 Cedra Names Service - Domain Utilities"
        echo "=========================================="
        echo ""
        echo "Usage: $0 <command> [arguments]"
        echo ""
        echo "Commands:"
        echo "  register <domain_name> [years]     - Register a domain"
        echo "  subdomain <sub> <domain> <exp>     - Register a subdomain"
        echo "  set-address <domain> <address>    - Set domain target address"
        echo "  set-reverse <domain>              - Set reverse lookup"
        echo "  check <domain>                    - Check domain availability"
        echo "  info <domain>                     - Get domain information"
        echo ""
        echo "Examples:"
        echo "  $0 register mydomain 2"
        echo "  $0 subdomain www mydomain 1735689600"
        echo "  $0 set-address mydomain 0x123..."
        echo "  $0 set-reverse mydomain"
        echo ""
        echo "Account: $ACCOUNT"
        ;;
esac
