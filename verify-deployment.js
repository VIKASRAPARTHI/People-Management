#!/usr/bin/env node

/**
 * 🔍 Deployment Verification Script
 * Verifies that your Vercel deployment is working correctly
 */

const https = require('https');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  purple: '\x1b[35m',
  cyan: '\x1b[36m'
};

function colorLog(color, message) {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function makeRequest(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          data: data,
          headers: res.headers
        });
      });
    }).on('error', (err) => {
      reject(err);
    });
  });
}

async function verifyBackend(backendUrl) {
  colorLog('cyan', '\n🔍 Verifying Backend...');
  
  try {
    // Test health endpoint
    const healthUrl = `${backendUrl}/api/health`;
    colorLog('blue', `Testing: ${healthUrl}`);
    
    const response = await makeRequest(healthUrl);
    
    if (response.statusCode === 200) {
      colorLog('green', '✅ Backend health check passed');
      
      try {
        const data = JSON.parse(response.data);
        if (data.success) {
          colorLog('green', '✅ Backend API is responding correctly');
          return true;
        } else {
          colorLog('red', '❌ Backend API returned error response');
          return false;
        }
      } catch (e) {
        colorLog('yellow', '⚠️  Backend responded but with invalid JSON');
        return false;
      }
    } else {
      colorLog('red', `❌ Backend health check failed with status: ${response.statusCode}`);
      return false;
    }
  } catch (error) {
    colorLog('red', `❌ Backend verification failed: ${error.message}`);
    return false;
  }
}

async function verifyFrontend(frontendUrl) {
  colorLog('cyan', '\n🔍 Verifying Frontend...');
  
  try {
    colorLog('blue', `Testing: ${frontendUrl}`);
    
    const response = await makeRequest(frontendUrl);
    
    if (response.statusCode === 200) {
      if (response.data.includes('<title>') && response.data.includes('</title>')) {
        colorLog('green', '✅ Frontend is accessible and serving HTML');
        
        if (response.data.includes('people-manager') || response.data.includes('People Manager')) {
          colorLog('green', '✅ Frontend appears to be the correct application');
          return true;
        } else {
          colorLog('yellow', '⚠️  Frontend is accessible but may not be the correct app');
          return true;
        }
      } else {
        colorLog('yellow', '⚠️  Frontend responded but may not be serving correct content');
        return false;
      }
    } else {
      colorLog('red', `❌ Frontend verification failed with status: ${response.statusCode}`);
      return false;
    }
  } catch (error) {
    colorLog('red', `❌ Frontend verification failed: ${error.message}`);
    return false;
  }
}

function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer.trim());
    });
  });
}

async function main() {
  colorLog('purple', '================================================');
  colorLog('purple', '  🔍 Vercel Deployment Verification Tool');
  colorLog('purple', '================================================\n');
  
  colorLog('blue', 'This tool will verify that your Vercel deployment is working correctly.\n');
  
  // Get Backend URL
  const backendUrl = await askQuestion('Enter your Backend Vercel URL (e.g., https://your-backend.vercel.app): ');
  
  if (!backendUrl.startsWith('https://')) {
    colorLog('red', '❌ Please enter a valid HTTPS URL for the backend');
    rl.close();
    return;
  }
  
  // Get Frontend URL
  const frontendUrl = await askQuestion('Enter your Frontend Vercel URL (e.g., https://your-frontend.vercel.app): ');
  
  if (!frontendUrl.startsWith('https://')) {
    colorLog('red', '❌ Please enter a valid HTTPS URL for the frontend');
    rl.close();
    return;
  }
  
  colorLog('cyan', '\n🚀 Starting verification process...');
  
  // Verify Backend
  const backendOk = await verifyBackend(backendUrl);
  
  // Verify Frontend
  const frontendOk = await verifyFrontend(frontendUrl);
  
  // Summary
  colorLog('purple', '\n================================================');
  colorLog('purple', '  📊 Verification Summary');
  colorLog('purple', '================================================');
  
  colorLog(backendOk ? 'green' : 'red', `Backend:  ${backendOk ? '✅ PASS' : '❌ FAIL'}`);
  colorLog(frontendOk ? 'green' : 'red', `Frontend: ${frontendOk ? '✅ PASS' : '❌ FAIL'}`);
  
  if (backendOk && frontendOk) {
    colorLog('green', '\n🎉 All verifications passed!');
    colorLog('blue', '\nNext steps:');
    colorLog('blue', '1. Visit your frontend URL in a browser');
    colorLog('blue', '2. Test adding, editing, and deleting people');
    colorLog('blue', '3. Check browser console for any errors');
    colorLog('blue', '4. Verify data persists after page refresh');
  } else {
    colorLog('red', '\n❌ Some verifications failed.');
    colorLog('yellow', '\nTroubleshooting steps:');
    
    if (!backendOk) {
      colorLog('yellow', '• Check Backend environment variables in Vercel Dashboard');
      colorLog('yellow', '• Verify MongoDB connection string is correct');
      colorLog('yellow', '• Check Vercel function logs for errors');
    }
    
    if (!frontendOk) {
      colorLog('yellow', '• Verify Frontend build was successful');
      colorLog('yellow', '• Check if Frontend environment.prod.ts has correct API URL');
      colorLog('yellow', '• Ensure Frontend deployment completed without errors');
    }
    
    colorLog('blue', '\n📖 See DEPLOYMENT_GUIDE.md for detailed troubleshooting');
  }
  
  colorLog('blue', '\n📋 Use DEPLOYMENT_CHECKLIST.md to verify all configuration steps');
  
  rl.close();
}

// Handle Ctrl+C gracefully
process.on('SIGINT', () => {
  colorLog('yellow', '\n\n⚠️  Verification cancelled by user');
  rl.close();
  process.exit(0);
});

main().catch((error) => {
  colorLog('red', `\n❌ Verification script error: ${error.message}`);
  rl.close();
  process.exit(1);
});
