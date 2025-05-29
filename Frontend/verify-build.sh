#!/bin/bash

# Build Verification Script for People Manager
# This script verifies that the production build is complete and ready for deployment

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
    echo -e "${BLUE}  Build Verification Report${NC}"
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

# Check if dist directory exists
check_dist_directory() {
    if [ -d "dist/people-manager" ]; then
        print_success "Build directory exists: dist/people-manager"
        return 0
    else
        print_error "Build directory not found: dist/people-manager"
        print_info "Run 'ng build --prod' to create the build"
        return 1
    fi
}

# Check required files
check_required_files() {
    local files=(
        "dist/people-manager/index.html"
        "dist/people-manager/main-es2015.*.js"
        "dist/people-manager/main-es5.*.js"
        "dist/people-manager/polyfills-es2015.*.js"
        "dist/people-manager/polyfills-es5.*.js"
        "dist/people-manager/runtime-es2015.*.js"
        "dist/people-manager/runtime-es5.*.js"
        "dist/people-manager/styles.*.css"
        "dist/people-manager/favicon.ico"
    )

    local all_found=true

    for file_pattern in "${files[@]}"; do
        if ls $file_pattern 1> /dev/null 2>&1; then
            local actual_file=$(ls $file_pattern | head -1)
            local file_size=$(du -h "$actual_file" | cut -f1)
            print_success "Found: $(basename "$actual_file") ($file_size)"
        else
            print_error "Missing: $file_pattern"
            all_found=false
        fi
    done

    return $all_found
}

# Check file sizes
check_file_sizes() {
    print_info "Checking bundle sizes..."
    
    # Check main bundles
    local main_es2015=$(ls dist/people-manager/main-es2015.*.js 2>/dev/null | head -1)
    local main_es5=$(ls dist/people-manager/main-es5.*.js 2>/dev/null | head -1)
    
    if [ -f "$main_es2015" ]; then
        local size_es2015=$(du -h "$main_es2015" | cut -f1)
        print_info "Main ES2015 bundle: $size_es2015"
        
        # Check if size is reasonable (should be around 500-600KB)
        local size_bytes=$(stat -f%z "$main_es2015" 2>/dev/null || stat -c%s "$main_es2015" 2>/dev/null)
        if [ "$size_bytes" -gt 1000000 ]; then
            print_warning "Main bundle is large (${size_es2015}). Consider code splitting."
        else
            print_success "Main bundle size is acceptable (${size_es2015})"
        fi
    fi
    
    if [ -f "$main_es5" ]; then
        local size_es5=$(du -h "$main_es5" | cut -f1)
        print_info "Main ES5 bundle: $size_es5"
    fi
}

# Check index.html content
check_index_html() {
    local index_file="dist/people-manager/index.html"
    
    if [ -f "$index_file" ]; then
        # Check if it contains the app root
        if grep -q "<app-root>" "$index_file"; then
            print_success "index.html contains app-root element"
        else
            print_error "index.html missing app-root element"
            return 1
        fi
        
        # Check if it references the bundles
        if grep -q "main-es2015" "$index_file" && grep -q "main-es5" "$index_file"; then
            print_success "index.html references both ES2015 and ES5 bundles"
        else
            print_warning "index.html may not have differential loading configured"
        fi
        
        # Check if it has the base href
        if grep -q 'base href="/"' "$index_file"; then
            print_success "index.html has correct base href"
        else
            print_warning "index.html base href may need adjustment for subdirectory deployment"
        fi
    else
        print_error "index.html not found"
        return 1
    fi
}

# Check deployment configuration files
check_deployment_configs() {
    print_info "Checking deployment configuration files..."
    
    local configs=(
        "vercel.json:Vercel deployment"
        "docker-compose.yml:Docker Compose"
        "Dockerfile:Docker container"
        "nginx.conf:Nginx configuration"
        "deploy.sh:Deployment script"
    )
    
    for config in "${configs[@]}"; do
        local file="${config%%:*}"
        local description="${config##*:}"
        
        if [ -f "$file" ]; then
            print_success "$description: $file"
        else
            print_warning "$description: $file (not found)"
        fi
    done
}

# Calculate total bundle size
calculate_total_size() {
    print_info "Calculating total deployment size..."
    
    local total_size=$(du -sh dist/people-manager 2>/dev/null | cut -f1)
    print_info "Total deployment size: $total_size"
    
    # Estimate gzipped size (roughly 30% of original)
    local size_bytes=$(du -s dist/people-manager 2>/dev/null | cut -f1)
    local estimated_gzip=$((size_bytes * 30 / 100))
    print_info "Estimated gzipped size: ~${estimated_gzip}KB"
}

# Show deployment options
show_deployment_options() {
    echo ""
    print_info "Ready for deployment! Choose your deployment method:"
    echo ""
    echo "  🚀 Quick Deploy Options:"
    echo "    ./deploy.sh vercel      - Deploy to Vercel"
    echo "    ./deploy.sh netlify     - Deploy to Netlify"
    echo "    ./deploy.sh firebase    - Deploy to Firebase"
    echo "    ./deploy.sh docker      - Build Docker image"
    echo ""
    echo "  📁 Manual Deploy:"
    echo "    Upload dist/people-manager/ contents to your hosting provider"
    echo ""
    echo "  🔗 Test Locally:"
    echo "    npx http-server dist/people-manager -p 8080"
    echo "    Then open http://localhost:8080"
    echo ""
}

# Main verification function
main() {
    print_header
    
    local all_checks_passed=true
    
    # Run all checks
    if ! check_dist_directory; then
        exit 1
    fi
    
    if ! check_required_files; then
        all_checks_passed=false
    fi
    
    check_file_sizes
    
    if ! check_index_html; then
        all_checks_passed=false
    fi
    
    check_deployment_configs
    calculate_total_size
    
    echo ""
    if [ "$all_checks_passed" = true ]; then
        print_success "All verification checks passed!"
        print_success "Build is ready for deployment 🎉"
        show_deployment_options
    else
        print_error "Some verification checks failed"
        print_info "Please fix the issues above before deploying"
        exit 1
    fi
}

# Run main function
main "$@"
