@echo off
REM 🚀 Windows Batch Script for Vercel Deployment
REM Deploys both Frontend and Backend to Vercel

echo ================================================
echo   🚀 People Management App - Vercel Deployment
echo ================================================
echo.

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

echo ✅ Project structure verified

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Vercel CLI not found. Installing...
    npm install -g vercel
    if errorlevel 1 (
        echo ❌ Failed to install Vercel CLI
        pause
        exit /b 1
    )
    echo ✅ Vercel CLI installed
) else (
    echo ✅ Vercel CLI is available
)

REM Check if user is logged in
vercel whoami >nul 2>&1
if errorlevel 1 (
    echo ℹ️  Please log in to Vercel...
    vercel login
    if errorlevel 1 (
        echo ❌ Failed to log in to Vercel
        pause
        exit /b 1
    )
) else (
    echo ✅ Logged in to Vercel
)

echo.
echo 🔄 Building Frontend...
cd Frontend

REM Install dependencies if needed
if not exist "node_modules" (
    echo 📦 Installing Frontend dependencies...
    npm install
    if errorlevel 1 (
        echo ❌ Failed to install Frontend dependencies
        pause
        exit /b 1
    )
)

REM Build the application
echo 🏗️ Building Angular application...
npm run build
if errorlevel 1 (
    echo ❌ Frontend build failed
    pause
    exit /b 1
)

echo ✅ Frontend build successful!
cd ..

echo.
echo 🔄 Preparing Backend...
cd Backend

REM Install dependencies if needed
if not exist "node_modules" (
    echo 📦 Installing Backend dependencies...
    npm install
    if errorlevel 1 (
        echo ❌ Failed to install Backend dependencies
        pause
        exit /b 1
    )
)

echo ✅ Backend ready for deployment!
cd ..

echo.
echo 🚀 Deploying Backend to Vercel...
cd Backend
vercel --prod
if errorlevel 1 (
    echo ❌ Backend deployment failed
    pause
    exit /b 1
)

echo ✅ Backend deployed successfully!
echo ⚠️  IMPORTANT: Note your Backend URL for Frontend configuration
cd ..

echo.
echo 🚀 Deploying Frontend to Vercel...
cd Frontend
vercel --prod
if errorlevel 1 (
    echo ❌ Frontend deployment failed
    pause
    exit /b 1
)

echo ✅ Frontend deployed successfully!
echo ⚠️  IMPORTANT: Note your Frontend URL for Backend CORS configuration
cd ..

echo.
echo ================================================
echo   🎉 Deployment Completed!
echo ================================================
echo.
echo ⚠️  CRITICAL: Complete these steps to make your app work:
echo.
echo 1. 🗄️ Set up MongoDB Atlas:
echo    • Go to https://mongodb.com/atlas
echo    • Create a free cluster
echo    • Create database user with read/write permissions
echo    • Whitelist all IPs (0.0.0.0/0) for Vercel
echo    • Get your connection string
echo.
echo 2. 🔧 Configure Backend Environment Variables:
echo    • Go to your Backend project in Vercel Dashboard
echo    • Navigate to Settings → Environment Variables
echo    • Add: MONGODB_URI=your_mongodb_connection_string
echo    • Add: CORS_ORIGIN=https://your-frontend-url.vercel.app
echo    • Add: NODE_ENV=production
echo    • Redeploy Backend after adding variables
echo.
echo 3. 🎨 Update Frontend Environment:
echo    • Edit Frontend/src/environments/environment.prod.ts
echo    • Replace apiUrl with: https://your-backend-url.vercel.app/api
echo    • Redeploy Frontend
echo.
echo 4. ✅ Test Your Application:
echo    • Visit your Frontend URL
echo    • Test adding, editing, and deleting people
echo    • Check browser console for any errors
echo.
echo 📖 For detailed instructions, see DEPLOYMENT_GUIDE.md
echo 📋 Use DEPLOYMENT_CHECKLIST.md to verify everything works
echo.
pause
