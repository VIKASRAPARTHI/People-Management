# 🚀 People Management App - Vercel Deployment

A complete full-stack People Management application with Angular frontend and Node.js backend, ready for deployment on Vercel.

## 📋 Quick Start Deployment

### Option 1: Automated Deployment (Recommended)

**For Linux/Mac:**
```bash
chmod +x deploy-to-vercel.sh
./deploy-to-vercel.sh
```

**For Windows:**
```cmd
deploy-to-vercel.bat
```

**Using npm scripts:**
```bash
# Install dependencies for both frontend and backend
npm run install:all

# Build both applications
npm run build:all

# Deploy (Linux/Mac)
npm run deploy

# Deploy (Windows)
npm run deploy:windows

# Verify deployment after completion
npm run verify
```

### Option 2: Manual Step-by-Step Deployment

1. **Deploy Backend:**
   ```bash
   cd Backend
   vercel --prod
   ```

2. **Deploy Frontend:**
   ```bash
   cd Frontend
   vercel --prod
   ```

3. **Configure Environment Variables** (see detailed guide below)

## 📁 Project Structure

```
Angular Project/
├── Frontend/                 # Angular application
│   ├── src/
│   ├── dist/people-manager/  # Built application
│   ├── vercel.json          # Frontend deployment config
│   └── package.json
├── Backend/                  # Node.js API
│   ├── server.js            # Main server file
│   ├── vercel.json          # Backend deployment config
│   ├── .env.production      # Production environment template
│   └── package.json
├── vercel.json              # Root deployment config (monorepo)
├── .env.example             # Environment variables template
├── deploy-to-vercel.sh      # Linux/Mac deployment script
├── deploy-to-vercel.bat     # Windows deployment script
├── DEPLOYMENT_GUIDE.md      # Detailed deployment instructions
├── DEPLOYMENT_CHECKLIST.md  # Step-by-step checklist
└── README_DEPLOYMENT.md     # This file
```

## 🔧 Environment Configuration

### Backend Environment Variables (Set in Vercel Dashboard)

```env
NODE_ENV=production
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/person_management?retryWrites=true&w=majority
CORS_ORIGIN=https://your-frontend-app.vercel.app
```

### Frontend Environment (Update in code)

Edit `Frontend/src/environments/environment.prod.ts`:
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://your-backend-app.vercel.app/api'
};
```

## 🗄️ MongoDB Atlas Setup

1. Create account at [mongodb.com/atlas](https://mongodb.com/atlas)
2. Create a free cluster
3. Create database user with read/write permissions
4. Whitelist all IPs (0.0.0.0/0) for Vercel
5. Get connection string and add to Vercel environment variables

## 📋 Deployment Checklist

Use the [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) to ensure all steps are completed correctly.

### Quick Verification

1. **Backend Health Check:**
   ```bash
   curl https://your-backend-app.vercel.app/api/health
   ```

2. **Frontend Access:**
   Visit `https://your-frontend-app.vercel.app`

3. **Full Integration Test:**
   - Add a new person
   - Edit existing person
   - Delete a person
   - Verify data persists

## 🎯 Features

### Frontend (Angular)
- ✅ Material Design UI
- ✅ Responsive design
- ✅ Add/Edit/Delete people
- ✅ Real-time updates
- ✅ Form validation
- ✅ Production optimized build

### Backend (Node.js/Express)
- ✅ RESTful API
- ✅ MongoDB integration
- ✅ CORS configuration
- ✅ Error handling
- ✅ Health check endpoint
- ✅ Serverless deployment ready

### Database (MongoDB Atlas)
- ✅ Cloud-hosted MongoDB
- ✅ Automatic scaling
- ✅ Built-in security
- ✅ Free tier available

## 🔍 Troubleshooting

### Common Issues

1. **CORS Errors**
   - Verify `CORS_ORIGIN` matches Frontend URL exactly
   - Check for trailing slashes

2. **MongoDB Connection Issues**
   - Verify connection string format
   - Check IP whitelist (use 0.0.0.0/0 for Vercel)
   - Ensure database user has correct permissions

3. **Build Errors**
   - Use Node.js 18.x
   - Clear node_modules and reinstall if needed
   - Check for TypeScript errors

4. **API Not Found**
   - Verify Backend deployment was successful
   - Check Vercel function logs
   - Ensure routes are properly configured

### Debugging Steps

1. Check Vercel function logs in dashboard
2. Use browser developer tools for network inspection
3. Test API endpoints with curl/Postman
4. Verify environment variables in Vercel dashboard

## 📚 Documentation

- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Comprehensive deployment guide
- [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - Step-by-step checklist
- [.env.example](./.env.example) - Environment variables template

## 🆘 Support

If you encounter issues:

1. Review the deployment checklist
2. Check Vercel function logs
3. Verify all environment variables
4. Test individual components (Backend API, Frontend)
5. Check MongoDB Atlas connection

## 🎉 Success!

Once deployed, your application will be available at:
- **Frontend**: `https://your-frontend-app.vercel.app`
- **Backend API**: `https://your-backend-app.vercel.app/api`

The application provides a complete people management system with:
- Modern Angular frontend
- Scalable Node.js backend
- Cloud MongoDB database
- Global CDN distribution
- Automatic SSL certificates
- Serverless scaling

---

**Ready to deploy?** Run the deployment script and follow the post-deployment configuration steps!
