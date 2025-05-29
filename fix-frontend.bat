@echo off
echo ================================================
echo   🔧 Fixing Frontend Deployment Issues
echo ================================================
echo.

echo ✅ Frontend environment.prod.ts has been updated with:
echo    apiUrl: 'https://peoplemanagementbackend.vercel.app/api'
echo.

echo 🔄 Step 1: Rebuilding Frontend...
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
echo   🎯 Next Steps:
echo ================================================
echo.
echo 1. 🗄️ Set Backend Environment Variables:
echo    • Go to https://vercel.com/dashboard
echo    • Find your BACKEND project
echo    • Go to Settings → Environment Variables
echo    • Add these variables:
echo.
echo      MONGODB_URI=your_mongodb_connection_string
echo      NODE_ENV=production
echo      CORS_ORIGIN=https://peoplemanagementfrontend.vercel.app
echo.
echo 2. 🔄 Redeploy Backend after adding variables:
echo    cd Backend
echo    vercel --prod
echo.
echo 3. 🧪 Test your backend:
echo    https://peoplemanagementbackend.vercel.app/api/health
echo.
echo 4. 🌐 Test your frontend:
echo    https://peoplemanagementfrontend.vercel.app
echo.
echo 5. 🔍 If still empty, check browser console (F12) for errors
echo.
pause
