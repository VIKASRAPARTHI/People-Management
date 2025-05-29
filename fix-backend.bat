@echo off
echo ================================================
echo   🔧 Backend Fix Script
echo ================================================
echo.

echo ❌ Current Issue: Backend returning success: false
echo 💡 This means the API routes are not working properly
echo.

echo 🔧 REQUIRED: Set Environment Variables in Vercel Dashboard
echo.
echo 1. 🌐 Go to: https://vercel.com/dashboard
echo 2. 🎯 Click on your BACKEND project: peoplemanagementbackend
echo 3. ⚙️  Go to Settings → Environment Variables
echo 4. ➕ Add these variables:
echo.
echo    Variable Name: MONGODB_URI
echo    Value: mongodb+srv://username:password@cluster.mongodb.net/person_management?retryWrites=true^&w=majority
echo    (Replace with your actual MongoDB Atlas connection string)
echo.
echo    Variable Name: NODE_ENV
echo    Value: production
echo.
echo    Variable Name: CORS_ORIGIN
echo    Value: https://peoplemanagementfrontend.vercel.app
echo.
echo 5. 💾 Save the variables
echo.
pause

echo 🔄 Redeploying Backend with environment variables...
cd Backend
vercel --prod
if errorlevel 1 (
    echo ❌ Backend deployment failed
    pause
    exit /b 1
)
echo ✅ Backend redeployed!
echo.

cd ..

echo ================================================
echo   🧪 Testing Backend
echo ================================================
echo.
echo 1. 🌐 Test health endpoint:
echo    https://peoplemanagementbackend.vercel.app/api/health
echo.
echo    ✅ Should return: {"success": true, "message": "Person Management API is running"}
echo    ❌ If still "success": false, check Vercel function logs
echo.
echo 2. 🌐 Test people endpoint:
echo    https://peoplemanagementbackend.vercel.app/api/people
echo.
echo 3. 🔍 If still not working:
echo    • Check Vercel Dashboard → Functions → View logs
echo    • Verify MongoDB Atlas connection string
echo    • Ensure MongoDB Atlas allows all IPs (0.0.0.0/0)
echo.
echo 4. 🎯 Once backend works, test frontend:
echo    https://peoplemanagementfrontend.vercel.app
echo.
pause
