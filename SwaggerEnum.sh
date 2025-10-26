#!/bin/bash

# Comprehensive Swagger Endpoint Discovery Script
# Covers all technologies and frameworks

if [ $# -eq 0 ]; then
    echo "Usage: $0 <urls_file> [output_file]"
    echo "Example: $0 urls.txt swagger_results.txt"
    exit 1
fi

URLS_FILE="$1"
OUTPUT_FILE="${2:-swagger_results.txt}"

# Create comprehensive Swagger endpoints wordlist
cat > swagger_complete_wordlist.txt << 'EOF'
# Standard Swagger/OpenAPI
/api-docs
/api-docs/swagger.json
/api-docs/swagger.yaml
/swagger
/swagger.json
/swagger.yaml
/swagger-ui.html
/swagger-ui
/swagger-ui/index.html
/swagger/index.html
/api/swagger.json
/api/swagger.yaml
/api/swagger-ui.html

# Versioned API Docs
/v1/api-docs
/v2/api-docs
/v3/api-docs
/v1/swagger.json
/v2/swagger.json
/v3/swagger.json
/api/v1/swagger.json
/api/v2/swagger.json
/api/v3/swagger.json
/api/v1/api-docs
/api/v2/api-docs
/api/v3/api-docs

# OpenAPI 3.0
/openapi
/openapi.json
/openapi.yaml
/openapi.yml
/v3/api-docs
/api/openapi.json
/api/openapi.yaml

# Spring Boot
/actuator/swagger
/actuator/api-docs
/springfox/swagger.json
/springfox/api-docs

# ASP.NET
/swagger/docs/v1
/swagger/ui/index
/swagger/v1/swagger.json

# Node.js/Express
/api-docs.json
/api/docs
/docs/api
/docs/swagger

# Python/Django/Flask
/docs/swagger
/docs/api
/apidocs
/apidocs/swagger.json

# Ruby on Rails
/api/swagger_doc
/api/docs

# PHP/Laravel
/api/doc
/api/documentation
/docs/api

# Alternative Paths
/developer/swagger.json
/developer/api-docs
/dev/swagger.json
/dev/api-docs
/test/swagger.json
/test/api-docs
/staging/swagger.json
/staging/api-docs
/production/swagger.json
/production/api-docs

# Common Variations
/api.json
/api.yaml
/api.yml
/swagger/api-docs
/swagger/api
/api/swagger
/api/swagger-ui

# UI Resources
/webjars/swagger-ui
/webjars/springfox-swagger-ui
/static/swagger-ui
/assets/swagger-ui
/public/swagger-ui
/resources/swagger-ui

# Swagger Configuration
/swagger-resources
/swagger-resources/configuration/ui
/swagger-resources/configuration/security
/swagger-config.json
/swagger-config.yaml

# Legacy Paths
/api-documentation
/api-specification
/api-spec
/api-specs
/api-definition
/api-definitions

# Framework Specific
/rails/swagger
/django/swagger
/flask/swagger
/laravel/swagger
/express/swagger
/nestjs/swagger
/fastapi/docs
/fastapi/openapi.json

# Cloud & Microservices
/gateway/swagger
/gateway/api-docs
/microservice/swagger
/service/api-docs

# Admin & Internal
/admin/swagger
/admin/api-docs
/internal/swagger
/internal/api-docs
/management/swagger
/management/api-docs

# Common API Patterns
/rest/api-docs
/rest/swagger.json
/restapi/swagger.json
/rest-api/swagger.json
/webservice/api-docs
/webservice/swagger.json

# File Extensions
/swagger.json.gz
/swagger.yaml.gz
/api-docs.zip
/swagger.zip

# Backup Files
/swagger.json.bak
/swagger.yaml.bak
/api-docs.bak
/swagger.json.backup
/swagger.yaml.backup

# Development Files
/swagger.json.dev
/swagger.yaml.dev
/api-docs.dev
/swagger.json.local
/swagger.yaml.local

# Testing Environments
/swagger.json.test
/swagger.yaml.test
/api-docs.test
/swagger.json.staging
/swagger.yaml.staging

# Authentication Endpoints
/auth/swagger
/auth/api-docs
/oauth/swagger
/oauth2/swagger
/identity/swagger

# Documentation Portals
/documentation/swagger
/documentation/api-docs
/docs/swagger.json
/docs/api-docs
/help/swagger
/help/api-docs

# API Gateway Specific
/kong/swagger
/kong-api/swagger
/apigee/swagger
/aws-api/swagger
/azure-api/swagger

# Monitoring & Metrics
/metrics/swagger
/monitoring/swagger
/health/swagger
/status/swagger

# Database APIs
/db/swagger
/database/swagger
/mongo/swagger
/redis/swagger

# Mobile APIs
/mobile/swagger
/mobile/api-docs
/app/swagger
/app/api-docs
/ios/swagger
/android/swagger

# Third-party Integrations
/stripe/swagger
/twilio/swagger
/sendgrid/swagger
/twilio/swagger

# Country/Language Specific
/us/swagger
/eu/swagger
/uk/swagger
/fr/swagger
/de/swagger
/jp/swagger

# Industry Specific
/banking/swagger
/healthcare/swagger
/retail/swagger
/finance/swagger
/insurance/swagger

# Alternative Names
/open-api
/open-apis
/api-schema
/api-schemas
/api-description
/api-descriptions

# Archive & Historical
/archive/swagger
/archive/api-docs
/historical/swagger
/old/swagger
/old/api-docs
/legacy/swagger
/legacy/api-docs

# Case Variations
/Swagger
/SWAGGER
/Api-docs
/API-DOCS
/Swagger-UI
/SWAGGER-UI

# Subdomain Patterns (for manual testing)
# api-docs.example.com
# swagger.example.com
# docs.example.com
# api.example.com/swagger

# Query Parameters (for manual testing)
# ?swagger
# ?api-docs
# ?format=swagger
# ?output=swagger
# ?doc=swagger
EOF

echo "🔍 Comprehensive Swagger Endpoint Discovery"
echo "📁 Input: $URLS_FILE"
echo "💾 Output: $OUTPUT_FILE"
echo "🔢 URLs to process: $(wc -l < "$URLS_FILE")"

# Count total paths
TOTAL_PATHS=$(grep -v '^#' swagger_complete_wordlist.txt | grep -v '^$' | wc -l)
echo "🛣️  Total Swagger paths: $TOTAL_PATHS"

# Create results directory
mkdir -p swagger_results
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🚀 Starting comprehensive Swagger scan..."
echo "⏰ Started at: $(date)"

# Scan function
scan_swagger() {
    local url=$1
    local path=$2
    local full_url="${url}${path}"
    
    # Skip comments and empty lines
    [[ "$path" =~ ^# ]] && return
    [[ -z "$path" ]] && return
    
    response=$(curl -s -w "%{http_code} %{size_download} %{content_type}" -o /tmp/swagger_temp_$$.txt "$full_url" 2>/dev/null)
    http_code=$(echo "$response" | awk '{print $1}')
    size=$(echo "$response" | awk '{print $2}')
    content_type=$(echo "$response" | awk '{print $3}')
    
    # Check for Swagger indicators
    if [ "$http_code" = "200" ]; then
        # Check content for Swagger keywords
        if grep -q -i "swagger\\|openapi\\|ApiDocumentation\\|Swagger UI" /tmp/swagger_temp_$$.txt 2>/dev/null || 
           [[ "$content_type" == *"json"* ]] && grep -q "\"swagger\"\\|\"openapi\"" /tmp/swagger_temp_$$.txt 2>/dev/null; then
            title=$(grep -o '<title>[^<]*' /tmp/swagger_temp_$$.txt | head -1 | sed 's/<title>//')
            echo "[SWAGGER] $full_url [$http_code] [$size] [$content_type] [$title]" | tee -a "$OUTPUT_FILE"
        fi
    fi
    
    rm -f /tmp/swagger_temp_$$.txt
}

export -f scan_swagger

# Perform scan with progress
CURRENT=0
while read -r path; do
    [[ "$path" =~ ^# ]] && continue
    [[ -z "$path" ]] && continue
    
    CURRENT=$((CURRENT + 1))
    echo -ne "⏳ Progress: $CURRENT/$TOTAL_PATHS - Testing: $path\r"
    
    # Test each URL with current path
    while read -r base_url; do
        scan_swagger "$base_url" "$path"
    done < "$URLS_FILE"
    
done < swagger_complete_wordlist.txt

echo -e "\n✅ Scan completed at: $(date)"

# Analyze results
if [ -f "$OUTPUT_FILE" ]; then
    TOTAL_FOUND=$(wc -l < "$OUTPUT_FILE" 2>/dev/null || echo 0)
    echo "📊 Total Swagger endpoints found: $TOTAL_FOUND"
    
    # Categorize results
    echo ""
    echo "📋 Results Summary:"
    echo "=================="
    grep -c "swagger.json" "$OUTPUT_FILE" | xargs echo "📄 Swagger JSON:"
    grep -c "api-docs" "$OUTPUT_FILE" | xargs echo "📚 API Docs:"
    grep -c "swagger-ui" "$OUTPUT_FILE" | xargs echo "🎨 Swagger UI:"
    grep -c "openapi" "$OUTPUT_FILE" | xargs echo "🔓 OpenAPI:"
    
    # Show sample findings
    if [ "$TOTAL_FOUND" -gt 0 ]; then
        echo ""
        echo "🔍 Sample discoveries:"
        head -10 "$OUTPUT_FILE" | while read line; do
            echo "   ✓ $line"
        done
    fi
else
    echo "❌ No Swagger endpoints found"
fi

# Save discovered endpoints for further analysis
if [ -f "$OUTPUT_FILE" ] && [ "$(wc -l < "$OUTPUT_FILE")" -gt 0 ]; then
    echo ""
    echo "💾 Extracting pure URLs for further testing..."
    grep -o 'http[s]*://[^ ]*' "$OUTPUT_FILE" > "swagger_urls_$TIMESTAMP.txt"
    echo "📄 Pure URLs saved to: swagger_urls_$TIMESTAMP.txt"
fi

# Cleanup
rm -f swagger_complete_wordlist.txt

echo ""
echo "🎯 Next steps:"
echo "   - Review $OUTPUT_FILE for findings"
echo "   - Test discovered endpoints for vulnerabilities"
echo "   - Check for sensitive information in Swagger docs"
