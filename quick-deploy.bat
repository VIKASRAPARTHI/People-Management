@echo off
echo ================================================
echo   🚀 Quick Vercel Deployment - People Management
echo ================================================
echo.

echo ⚠️  IMPORTANT: Before running this script:
echo 1. Set up MongoDB Atlas at https://mongodb.com/atlas
echo 2. Get your MongoDB connection string
echo 3. Have your Vercel account ready
echo.
pause

echo 🔄 Step 1: Deploying Backend...
cd Backend
echo Installing backend dependencies...
npm install
echo Deploying backend to Vercel...
vercel --prod
if errorlevel 1 (
    echo ❌ Backend deployment failed
    pause
    exit /b 1
)
echo ✅ Backend deployed!
echo.
echo ⚠️  IMPORTANT: 
echo 1. Go to Vercel Dashboard
echo 2. Find your backend project
echo 3. Go to Settings → Environment Variables
echo 4. Add these variables:
echo    MONGODB_URI=your_mongodb_connection_string
echo    NODE_ENV=production
echo    CORS_ORIGIN=https://your-frontend-url.vercel.app
echo 5. Redeploy backend after adding variables
echo.
echo 📝 Note your backend URL (e.g., https://your-backend-abc123.vercel.app)
echo.
pause

cd ..

echo 🔄 Step 2: Preparing Frontend...
echo.
echo ⚠️  BEFORE DEPLOYING FRONTEND:
echo 1. Edit Frontend/src/environments/environment.prod.ts
echo 2. Replace 'your-backend-app' with your actual backend URL
echo 3. Save the file
echo.
echo Example:
echo   apiUrl: 'https://your-actual-backend-url.vercel.app/api'
echo.
pause

echo 🔄 Step 3: Deploying Frontend...
cd Frontend
echo Installing frontend dependencies...
npm install
echo Building frontend...
npm run build
if errorlevel 1 (
    echo ❌ Frontend build failed
    pause
    exit /b 1
)
echo Deploying frontend to Vercel...
vercel --prod
if errorlevel 1 (
    echo ❌ Frontend deployment failed
    pause
    exit /b 1
)
echo ✅ Frontend deployed!
echo.
echo 📝 Note your frontend URL (e.g., https://your-frontend-abc123.vercel.app)
echo.

cd ..

echo ================================================
echo   🎉 Deployment Complete!
echo ================================================
echo.
echo 🔧 FINAL STEPS:
echo 1. Update backend CORS_ORIGIN with your frontend URL
echo 2. Redeploy backend
echo 3. Test your application
echo.
echo 🧪 Testing:
echo 1. Visit your frontend URL
echo 2. Try adding a person
echo 3. Check if data persists
echo.
echo 📖 If you have issues, check DEPLOYMENT_GUIDE.md
echo.
pause
