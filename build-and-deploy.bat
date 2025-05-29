@echo off
REM 🚀 Build and Deploy Script for Vercel (Windows)
REM This script builds the frontend and prepares both frontend and backend for deployment

echo 🎯 Starting build and deployment process...

REM Check if we're in the right directory
if not exist "Frontend" (
    echo ❌ Error: Frontend folder not found
    echo    Please run this script from the project root directory
    pause
    exit /b 1
)

if not exist "Backend" (
    echo ❌ Error: Backend folder not found
    echo    Please run this script from the project root directory
    pause
    exit /b 1
)

REM Build Frontend
echo 🔨 Building Frontend...
cd Frontend

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo 📦 Installing Frontend dependencies...
    call npm install
)

REM Build the application
echo 🏗️ Building Angular application...
call npm run build

if %errorlevel% neq 0 (
    echo ❌ Frontend build failed!
    pause
    exit /b 1
)

echo ✅ Frontend build successful!

REM Go back to root
cd ..

REM Check Backend dependencies
echo 🔍 Checking Backend...
cd Backend

if not exist "node_modules" (
    echo 📦 Installing Backend dependencies...
    call npm install
)

echo ✅ Backend ready for deployment!

REM Go back to root
cd ..

echo.
echo 🎉 Build process completed successfully!
echo.
echo 📋 Next steps:
echo 1. Set up MongoDB Atlas database
echo 2. Deploy Backend to Vercel:
echo    cd Backend ^&^& vercel --prod
echo 3. Update Frontend environment with backend URL
echo 4. Deploy Frontend to Vercel:
echo    cd Frontend ^&^& vercel --prod
echo 5. Update Backend CORS with frontend URL
echo.
echo 📖 See DEPLOYMENT_GUIDE.md for detailed instructions
echo.
pause
