#!/bin/bash

# 🚀 Complete Vercel Deployment Script
# Deploys both Frontend and Backend to Vercel with proper configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${PURPLE}================================================${NC}"
    echo -e "${PURPLE}  🚀 People Management App → Vercel Deployment${NC}"
    echo -e "${PURPLE}================================================${NC}"
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

print_step() {
    echo -e "${CYAN}🔄 $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check if we're in the right directory
    if [ ! -d "Frontend" ] || [ ! -d "Backend" ]; then
        print_error "Please run this script from the project root directory"
        print_error "Make sure both Frontend and Backend folders exist"
        exit 1
    fi
    
    # Check if Vercel CLI is installed
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI not found. Installing..."
        npm install -g vercel
        print_success "Vercel CLI installed"
    else
        print_success "Vercel CLI is available"
    fi
    
    # Check if user is logged in to Vercel
    if vercel whoami &> /dev/null; then
        local user=$(vercel whoami)
        print_success "Logged in to Vercel as: $user"
    else
        print_info "Please log in to Vercel..."
        vercel login
    fi
}

# Build Frontend
build_frontend() {
    print_step "Building Frontend..."
    cd Frontend
    
    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        print_info "Installing Frontend dependencies..."
        npm install
    fi
    
    # Build the application
    print_info "Building Angular application..."
    npm run build
    
    if [ $? -eq 0 ]; then
        print_success "Frontend build successful!"
    else
        print_error "Frontend build failed!"
        exit 1
    fi
    
    cd ..
}

# Prepare Backend
prepare_backend() {
    print_step "Preparing Backend..."
    cd Backend
    
    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        print_info "Installing Backend dependencies..."
        npm install
    fi
    
    print_success "Backend ready for deployment!"
    cd ..
}

# Deploy Backend
deploy_backend() {
    print_step "Deploying Backend to Vercel..."
    cd Backend
    
    echo ""
    print_info "Deploying Backend API..."
    vercel --prod
    
    if [ $? -eq 0 ]; then
        print_success "Backend deployed successfully!"
        echo ""
        print_warning "IMPORTANT: Note your Backend URL for Frontend configuration"
        print_info "Backend URL format: https://your-backend-name.vercel.app"
    else
        print_error "Backend deployment failed!"
        exit 1
    fi
    
    cd ..
}

# Deploy Frontend
deploy_frontend() {
    print_step "Deploying Frontend to Vercel..."
    cd Frontend
    
    echo ""
    print_info "Deploying Frontend application..."
    vercel --prod
    
    if [ $? -eq 0 ]; then
        print_success "Frontend deployed successfully!"
        echo ""
        print_warning "IMPORTANT: Note your Frontend URL for Backend CORS configuration"
        print_info "Frontend URL format: https://your-frontend-name.vercel.app"
    else
        print_error "Frontend deployment failed!"
        exit 1
    fi
    
    cd ..
}

# Show post-deployment instructions
show_post_deployment_instructions() {
    echo ""
    echo -e "${PURPLE}================================================${NC}"
    echo -e "${PURPLE}  🎉 Deployment Completed!${NC}"
    echo -e "${PURPLE}================================================${NC}"
    echo ""
    
    print_warning "CRITICAL: Complete these steps to make your app work:"
    echo ""
    
    print_info "1. 🗄️ Set up MongoDB Atlas:"
    echo "   • Go to https://mongodb.com/atlas"
    echo "   • Create a free cluster"
    echo "   • Create database user with read/write permissions"
    echo "   • Whitelist all IPs (0.0.0.0/0) for Vercel"
    echo "   • Get your connection string"
    echo ""
    
    print_info "2. 🔧 Configure Backend Environment Variables:"
    echo "   • Go to your Backend project in Vercel Dashboard"
    echo "   • Navigate to Settings → Environment Variables"
    echo "   • Add: MONGODB_URI=your_mongodb_connection_string"
    echo "   • Add: CORS_ORIGIN=https://your-frontend-url.vercel.app"
    echo "   • Add: NODE_ENV=production"
    echo "   • Redeploy Backend after adding variables"
    echo ""
    
    print_info "3. 🎨 Update Frontend Environment:"
    echo "   • Edit Frontend/src/environments/environment.prod.ts"
    echo "   • Replace apiUrl with: https://your-backend-url.vercel.app/api"
    echo "   • Redeploy Frontend"
    echo ""
    
    print_info "4. ✅ Test Your Application:"
    echo "   • Visit your Frontend URL"
    echo "   • Test adding, editing, and deleting people"
    echo "   • Check browser console for any errors"
    echo ""
    
    print_success "Your People Management App features:"
    echo "  ✅ Add, edit, delete people"
    echo "  ✅ Real-time updates"
    echo "  ✅ Mobile responsive design"
    echo "  ✅ Material Design UI"
    echo "  ✅ MongoDB persistence"
    echo "  ✅ Production optimized"
    echo ""
    
    print_info "📖 For detailed instructions, see DEPLOYMENT_GUIDE.md"
}

# Main deployment function
main() {
    print_header
    
    # Run deployment steps
    check_prerequisites
    build_frontend
    prepare_backend
    deploy_backend
    deploy_frontend
    
    # Show post-deployment instructions
    show_post_deployment_instructions
}

# Run main function
main "$@"
