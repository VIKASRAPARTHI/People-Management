# People Manager - Angular SPA

A modern, responsive people management application built with Angular 8 and Material Design.

## 🚀 Features

- **Modern UI**: Material Design components with professional styling
- **Real-time Updates**: Add, edit, and delete people with instant feedback
- **Sample Data**: Automatically loads 10 sample people from JSONPlaceholder API
- **Session Persistence**: Changes persist during browser session, reset on reload
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile
- **Single Page Application**: Optimized for fast loading and smooth navigation

## 🛠️ Technologies Used

- **Angular 8** - Modern web framework
- **Angular Material** - UI component library
- **TypeScript** - Type-safe JavaScript
- **RxJS** - Reactive programming
- **JSONPlaceholder API** - Sample data source

## 📦 Deployment to Vercel

### Prerequisites
- Node.js (v12 or higher)
- Vercel account

### Quick Deploy

1. **Clone/Download** this repository
2. **Install Vercel CLI** (if not already installed):
   ```bash
   npm install -g vercel
   ```

3. **Navigate to project directory**:
   ```bash
   cd people-manager
   ```

4. **Deploy to Vercel**:
   ```bash
   vercel
   ```

5. **Follow the prompts**:
   - Set up and deploy? **Y**
   - Which scope? Choose your account
   - Link to existing project? **N**
   - Project name? **people-manager** (or your preferred name)
   - Directory? **./dist/people-manager**
   - Want to override settings? **N**

### Alternative: Deploy via Vercel Dashboard

1. **Build the project**:
   ```bash
   npm run build
   ```

2. **Upload to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Upload the `dist/people-manager` folder
   - Deploy!

## 🔧 Local Development

### Install Dependencies
```bash
npm install
```

### Development Server
```bash
npm start
```
Navigate to `http://localhost:4200`

### Production Build
```bash
npm run build
```

## 📁 Project Structure

```
people-manager/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── people-list/     # Main list component
│   │   │   └── person-edit/     # Add/edit form component
│   │   ├── models/
│   │   │   └── person.model.ts  # Person interface
│   │   ├── services/
│   │   │   └── people.service.ts # Data service
│   │   └── app.module.ts        # Main module
│   ├── environments/            # Environment configs
│   └── styles.css              # Global styles
├── dist/                       # Production build output
├── vercel.json                 # Vercel configuration
└── package.json               # Dependencies and scripts
```

## 🌐 Live Demo

After deployment, your app will be available at:
`https://your-project-name.vercel.app`

## ✨ Key Features Explained

### Sample Data Management
- Loads 10 people automatically on startup
- Data persists during session
- Reloads original data on page refresh

### CRUD Operations
- **Create**: Add new people with validation
- **Read**: View all people in organized list
- **Update**: Edit existing people inline
- **Delete**: Remove people with single click

### Responsive Design
- Mobile-first approach
- Adaptive layouts for all screen sizes
- Touch-friendly interface

## 🔧 Configuration Files

### vercel.json
Configures Vercel for SPA routing and static file serving.

### angular.json
Optimized production build configuration with:
- Code splitting
- Tree shaking
- Minification
- AOT compilation

## 📱 Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## 🚀 Performance

- **Bundle Size**: ~665KB (ES5) / ~559KB (ES2015)
- **First Load**: < 2 seconds
- **Subsequent Navigation**: Instant (SPA)

---

**Ready to deploy! Your People Manager application is optimized for Vercel deployment.** 🎉
