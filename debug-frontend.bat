@echo off
echo ================================================
echo   🔍 Frontend Debug Script
echo ================================================
echo.

echo 🔄 Step 1: Rebuilding Frontend with updated config...
cd Frontend
npm run build
if errorlevel 1 (
    echo ❌ Frontend build failed
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
echo   🧪 Testing Instructions
echo ================================================
echo.
echo 1. 🌐 Open your frontend: https://peoplemanagementfrontend.vercel.app
echo.
echo 2. 🔍 Press F12 to open Developer Tools
echo.
echo 3. 📋 Check Console tab for errors:
echo    • Look for red error messages
echo    • Note any JavaScript errors
echo    • Check for API connection errors
echo.
echo 4. 🌐 Check Network tab:
echo    • Refresh the page
echo    • Look for failed requests (red entries)
echo    • Verify main.js, polyfills.js are loading
echo.
echo 5. 🔗 Test backend separately:
echo    https://peoplemanagementbackend.vercel.app/api/health
echo.
echo 6. 🔧 If backend fails, set environment variables:
echo    • Go to https://vercel.com/dashboard
echo    • Find BACKEND project
echo    • Settings → Environment Variables
echo    • Add: MONGODB_URI, NODE_ENV=production, CORS_ORIGIN
echo.
echo ================================================
echo   📋 Common Issues & Solutions
echo ================================================
echo.
echo ❌ Blank page + Console errors:
echo    → Check if API URL is correct in environment.prod.ts
echo    → Verify backend is responding
echo.
echo ❌ CORS errors in console:
echo    → Update backend CORS_ORIGIN environment variable
echo    → Redeploy backend
echo.
echo ❌ Network errors:
echo    → Check if backend environment variables are set
echo    → Verify MongoDB connection string
echo.
echo ❌ Build/deployment errors:
echo    → Check Node.js version (should be 18.x)
echo    → Clear node_modules and reinstall
echo.
pause
