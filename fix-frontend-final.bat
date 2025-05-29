@echo off
echo ================================================
echo   🎉 Backend Working! Now Fixing Frontend
echo ================================================
echo.

echo ✅ Backend health check passed!
echo ✅ API URL: https://peoplemanagementbackend.vercel.app/api
echo.

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
echo   🧪 Testing Instructions
echo ================================================
echo.
echo 1. 🌐 Open: https://peoplemanagementfrontend.vercel.app
echo.
echo 2. 🔍 If still blank, press F12 and check:
echo    📋 Console tab - Look for JavaScript errors
echo    🌐 Network tab - Check if files are loading
echo.
echo 3. 🧪 Test these backend endpoints work:
echo    https://peoplemanagementbackend.vercel.app/api/people
echo    https://peoplemanagementbackend.vercel.app/
echo.
echo 4. 🔧 Common issues if still blank:
echo    • CORS errors in console
echo    • JavaScript files not loading
echo    • Angular app not initializing
echo.
echo 5. 📋 If you see errors, tell me:
echo    • Exact error messages from console
echo    • What shows in Network tab
echo    • What happens when you test /api/people
echo.
pause
