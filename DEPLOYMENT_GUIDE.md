# 🚀 Vercel Deployment Guide

This guide will help you deploy both the frontend (Angular) and backend (Node.js) to Vercel.

## 📋 Prerequisites

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **MongoDB Atlas**: Set up a cloud MongoDB database at [mongodb.com/atlas](https://mongodb.com/atlas)
3. **Git Repository**: Push your code to GitHub, GitLab, or Bitbucket

## 🗄️ Step 1: Set Up MongoDB Atlas

1. Create a MongoDB Atlas account
2. Create a new cluster (free tier is fine)
3. Create a database user with read/write permissions
4. Get your connection string (it looks like):
   ```
   mongodb+srv://username:password@cluster.mongodb.net/person_management?retryWrites=true&w=majority
   ```

## 🔧 Step 2: Deploy Backend to Vercel

1. **Navigate to Backend folder**:
   ```bash
   cd Backend
   ```

2. **Install Vercel CLI** (if not already installed):
   ```bash
   npm install -g vercel
   ```

3. **Login to Vercel**:
   ```bash
   vercel login
   ```

4. **Deploy Backend**:
   ```bash
   vercel --prod
   ```

5. **Set Environment Variables** in Vercel Dashboard:
   - Go to your project in Vercel Dashboard
   - Navigate to Settings → Environment Variables
   - Add these variables:
     ```
     NODE_ENV=production
     MONGODB_URI=your_mongodb_atlas_connection_string
     CORS_ORIGIN=https://your-frontend-app.vercel.app
     ```

6. **Note your backend URL**: `https://your-backend-app.vercel.app`

## 🎨 Step 3: Deploy Frontend to Vercel

1. **Update Frontend Environment**:
   - Edit `Frontend/src/environments/environment.prod.ts`
   - Replace `your-backend-app.vercel.app` with your actual backend URL:
     ```typescript
     export const environment = {
       production: true,
       apiUrl: 'https://your-actual-backend-app.vercel.app/api'
     };
     ```

2. **Navigate to Frontend folder**:
   ```bash
   cd Frontend
   ```

3. **Deploy Frontend**:
   ```bash
   vercel --prod
   ```

4. **Update Backend CORS**:
   - Go to your backend project in Vercel Dashboard
   - Update the `CORS_ORIGIN` environment variable with your frontend URL
   - Redeploy the backend

## ✅ Step 4: Verify Deployment

1. **Test Backend API**:
   ```bash
   curl https://your-backend-app.vercel.app/api/health
   ```

2. **Test Frontend**:
   - Open `https://your-frontend-app.vercel.app`
   - Verify that the application loads and can fetch data

## 🔄 Step 5: Update URLs (Replace Placeholders)

Replace these placeholder URLs with your actual Vercel deployment URLs:

### Backend Environment Variables:
- `CORS_ORIGIN`: Your frontend Vercel URL

### Frontend Environment:
- `apiUrl`: Your backend Vercel URL + `/api`

## 📁 Project Structure for Deployment

```
Angular Project/
├── Backend/
│   ├── vercel.json          ✅ Ready
│   ├── .env.production      ✅ Ready (update MongoDB URI)
│   ├── server.js            ✅ Ready
│   └── package.json         ✅ Ready
├── Frontend/
│   ├── vercel.json          ✅ Ready
│   ├── dist/people-manager/ ✅ Built
│   └── package.json         ✅ Ready
└── DEPLOYMENT_GUIDE.md      ✅ This file
```

## 🎯 Quick Deployment Commands

### Backend:
```bash
cd Backend
vercel --prod
```

### Frontend:
```bash
cd Frontend
vercel --prod
```

## 🔧 Troubleshooting

### Common Issues:

1. **CORS Errors**: Make sure `CORS_ORIGIN` in backend matches your frontend URL
2. **MongoDB Connection**: Verify your MongoDB Atlas connection string and IP whitelist
3. **Build Errors**: Check Node.js version compatibility (use Node 18.x)
4. **API Not Found**: Ensure backend routes are working with `/api` prefix

### Environment Variables Checklist:

**Backend (Vercel Dashboard)**:
- ✅ `NODE_ENV=production`
- ✅ `MONGODB_URI=mongodb+srv://...`
- ✅ `CORS_ORIGIN=https://your-frontend.vercel.app`

**Frontend (Code)**:
- ✅ `environment.prod.ts` has correct `apiUrl`

## 🎉 Success!

Once deployed, your application will be available at:
- **Frontend**: `https://your-frontend-app.vercel.app`
- **Backend API**: `https://your-backend-app.vercel.app/api`

The application features:
- ✅ View people list
- ✅ Add new person
- ✅ Edit person details
- ✅ Delete person
- ✅ Real-time updates
- ✅ MongoDB persistence
