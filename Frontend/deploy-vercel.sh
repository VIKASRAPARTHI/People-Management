#!/bin/bash

# Vercel Deployment Script for People Manager
# Simple script to deploy to Vercel with verification

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  People Manager → Vercel${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Vercel CLI is installed
check_vercel_cli() {
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI not found. Installing..."
        npm install -g vercel
        print_success "Vercel CLI installed"
    else
        print_success "Vercel CLI is available"
    fi
}

# Check if user is logged in to Vercel
check_vercel_auth() {
    if vercel whoami &> /dev/null; then
        local user=$(vercel whoami)
        print_success "Logged in to Vercel as: $user"
    else
        print_info "Please log in to Vercel..."
        vercel login
    fi
}

# Verify build exists
check_build() {
    if [ -d "dist/people-manager" ]; then
        print_success "Build directory found"
        
        # Check key files
        if [ -f "dist/people-manager/index.html" ]; then
            print_success "index.html found"
        else
            print_error "index.html not found in build"
            return 1
        fi
        
        # Check bundle files
        if ls dist/people-manager/main-*.js 1> /dev/null 2>&1; then
            print_success "JavaScript bundles found"
        else
            print_error "JavaScript bundles not found"
            return 1
        fi
        
    else
        print_error "Build directory not found. Running build..."
        ng build --prod
        print_success "Build completed"
    fi
}

# Check vercel.json configuration
check_vercel_config() {
    if [ -f "vercel.json" ]; then
        print_success "vercel.json configuration found"
        
        # Verify it contains required fields
        if grep -q "dist/people-manager" vercel.json; then
            print_success "Output directory configured correctly"
        else
            print_warning "Output directory may not be configured"
        fi
        
    else
        print_error "vercel.json not found"
        return 1
    fi
}

# Deploy to Vercel
deploy_to_vercel() {
    print_info "Deploying to Vercel..."
    echo ""
    
    # Deploy with production flag
    vercel --prod
    
    echo ""
    print_success "Deployment completed!"
}

# Show post-deployment info
show_post_deployment_info() {
    echo ""
    print_info "🎉 Deployment successful!"
    echo ""
    print_info "Next steps:"
    echo "  1. Test your live application"
    echo "  2. Verify all functionality works"
    echo "  3. Check mobile responsiveness"
    echo "  4. Test delete functionality"
    echo ""
    print_info "Your People Manager features:"
    echo "  ✅ Add, edit, delete people"
    echo "  ✅ Instant delete with success messages"
    echo "  ✅ Mobile responsive design"
    echo "  ✅ Material Design UI"
    echo "  ✅ Production optimized"
    echo ""
    print_info "Vercel automatically provides:"
    echo "  🌐 Global CDN"
    echo "  🔒 Free SSL certificate"
    echo "  📊 Analytics (enable in dashboard)"
    echo "  🔄 Automatic deployments from Git"
    echo ""
}

# Main deployment function
main() {
    print_header
    
    # Run all checks
    check_vercel_cli
    check_vercel_auth
    check_build
    check_vercel_config
    
    # Deploy
    deploy_to_vercel
    
    # Show success info
    show_post_deployment_info
}

# Run main function
main "$@"
