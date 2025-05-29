#!/bin/bash

# 🚀 Build and Deploy Script for Vercel
# This script builds the frontend and prepares both frontend and backend for deployment

echo "🎯 Starting build and deployment process..."

# Check if we're in the right directory
if [ ! -d "Frontend" ] || [ ! -d "Backend" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   Make sure both Frontend and Backend folders exist"
    exit 1
fi

# Build Frontend
echo "🔨 Building Frontend..."
cd Frontend

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing Frontend dependencies..."
    npm install
fi

# Build the application
echo "🏗️ Building Angular application..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Frontend build successful!"
else
    echo "❌ Frontend build failed!"
    exit 1
fi

# Go back to root
cd ..

# Check Backend dependencies
echo "🔍 Checking Backend..."
cd Backend

if [ ! -d "node_modules" ]; then
    echo "📦 Installing Backend dependencies..."
    npm install
fi

echo "✅ Backend ready for deployment!"

# Go back to root
cd ..

echo ""
echo "🎉 Build process completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Set up MongoDB Atlas database"
echo "2. Deploy Backend to Vercel:"
echo "   cd Backend && vercel --prod"
echo "3. Update Frontend environment with backend URL"
echo "4. Deploy Frontend to Vercel:"
echo "   cd Frontend && vercel --prod"
echo "5. Update Backend CORS with frontend URL"
echo ""
echo "📖 See DEPLOYMENT_GUIDE.md for detailed instructions"
