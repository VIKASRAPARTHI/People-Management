@echo off
echo ================================================
echo   🔍 Frontend Debug and Fix Script
echo ================================================
echo.

echo 🎯 Backend is working, fixing frontend blank page...
echo.

echo 🔄 Step 1: Clean and rebuild Frontend...
cd Frontend

echo 🧹 Cleaning previous build...
if exist "dist" rmdir /s /q dist
if exist "node_modules" rmdir /s /q node_modules

echo 📦 Fresh install of dependencies...
npm install
if errorlevel 1 (
    echo ❌ npm install failed
    pause
    exit /b 1
)

echo 🏗️ Building with production configuration...
npm run build
if errorlevel 1 (
    echo ❌ Build failed - check errors above
    pause
    exit /b 1
)

echo ✅ Build successful!
echo.

echo 🔍 Checking build output...
if exist "dist\people-manager\index.html" (
    echo ✅ index.html exists
) else (
    echo ❌ index.html missing
    pause
    exit /b 1
)

if exist "dist\people-manager\main-*.js" (
    echo ✅ JavaScript bundles exist
) else (
    echo ❌ JavaScript bundles missing
    pause
    exit /b 1
)

echo 🚀 Step 2: Redeploying to Vercel...
vercel --prod
if errorlevel 1 (
    echo ❌ Deployment failed
    pause
    exit /b 1
)

echo ✅ Deployment successful!
echo.

cd ..

echo ================================================
echo   🧪 Testing and Debugging Instructions
echo ================================================
echo.
echo 1. 🌐 Open: https://peoplemanagementfrontend.vercel.app
echo.
echo 2. 🔍 Press F12 to open Developer Tools
echo.
echo 3. 📋 Check Console tab for errors:
echo    Common errors to look for:
echo    • CORS errors (blocked by CORS policy)
echo    • JavaScript errors (Cannot read property...)
echo    • Network errors (Failed to fetch)
echo    • Angular bootstrap errors
echo.
echo 4. 🌐 Check Network tab:
echo    • Refresh the page
echo    • Look for failed requests (red entries)
echo    • Check if main.js, polyfills.js are loading (status 200)
echo    • Look for API calls to backend
echo.
echo 5. 🧪 Test backend separately:
echo    https://peoplemanagementbackend.vercel.app/api/people
echo    Should return JSON with people data
echo.
echo 6. 🔧 If still blank, common fixes:
echo    • Clear browser cache (Ctrl+Shift+R)
echo    • Try incognito/private browsing mode
echo    • Check if backend CORS is set correctly
echo.
echo ================================================
echo   📋 Expected Results
echo ================================================
echo.
echo ✅ Working frontend should show:
echo    • "People Manager" toolbar at top
echo    • Table with 3 sample people (John Doe, Jane Smith, Alex Johnson)
echo    • "Add Person" button
echo    • Edit/Delete buttons for each person
echo.
echo ❌ If you see blank page:
echo    • Copy any console errors and share them
echo    • Check if JavaScript files are loading in Network tab
echo    • Verify backend CORS environment variable is set
echo.
echo 🔧 Backend CORS check:
echo    Go to Vercel Dashboard → peoplemanagementbackend → Settings → Environment Variables
echo    Ensure CORS_ORIGIN=https://peoplemanagementfrontend.vercel.app
echo.
pause
