@echo off
echo ================================================
echo   🔧 Complete Frontend Fix Script
echo ================================================
echo.

echo ⚠️  CRITICAL: First set Backend CORS environment variable!
echo.
echo 1. 🌐 Go to: https://vercel.com/dashboard
echo 2. 🎯 Click: peoplemanagementbackend project
echo 3. ⚙️  Go to: Settings → Environment Variables
echo 4. ➕ Add these variables:
echo.
echo    CORS_ORIGIN=https://peoplemanagementfrontend.vercel.app
echo    NODE_ENV=production
echo    MONGODB_URI=your_mongodb_connection_string
echo.
echo 5. 🔄 Redeploy backend after adding variables
echo.
pause

echo 🧪 Testing backend people endpoint...
echo 📋 Please test this URL in browser:
echo    https://peoplemanagementbackend.vercel.app/api/people
echo.
echo ✅ Should return: {"success":true,"data":[...people...],"count":3}
echo ❌ If error, check environment variables above
echo.
pause

echo 🔄 Step 1: Rebuilding Frontend...
cd Frontend

echo 📦 Installing dependencies...
npm install

echo 🏗️ Building application...
npm run build
if errorlevel 1 (
    echo ❌ Frontend build failed
    echo 🔍 Check for TypeScript or build errors above
    pause
    exit /b 1
)
echo ✅ Frontend build successful!
echo.

echo 🚀 Step 2: Redeploying Frontend...
vercel --prod
if errorlevel 1 (
    echo ❌ Frontend deployment failed
    pause
    exit /b 1
)
echo ✅ Frontend redeployed!
echo.

cd ..

echo ================================================
echo   🧪 Final Testing
echo ================================================
echo.
echo 1. 🌐 Test backend people API:
echo    https://peoplemanagementbackend.vercel.app/api/people
echo.
echo 2. 🌐 Test frontend application:
echo    https://peoplemanagementfrontend.vercel.app
echo.
echo 3. 🔍 If frontend still blank, press F12 and check:
echo    📋 Console tab - Look for CORS or API errors
echo    🌐 Network tab - Check if API calls are being made
echo.
echo 4. 📋 Expected behavior:
echo    ✅ Should show "People Manager" toolbar
echo    ✅ Should show table with 3 sample people
echo    ✅ Should have Add Person button
echo.
pause
