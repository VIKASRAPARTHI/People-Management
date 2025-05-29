const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const connectDB = require('./config/database');
const personRoutes = require('./routes/personRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Connect to MongoDB (optional - will work with in-memory data if MongoDB is not available)
connectDB().catch(err => {
    console.log('MongoDB not available, using in-memory data store');
});

// Middleware
const corsOptions = {
    origin: process.env.CORS_ORIGIN || process.env.FRONTEND_URL || 'http://localhost:4200',
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// API Routes
app.use('/api/people', personRoutes);

// Root route - API info
app.get('/', (req, res) => {
    res.json({
        success: true,
        message: 'Person Management API',
        version: '1.0.0',
        endpoints: {
            health: '/api/health',
            people: '/api/people'
        },
        timestamp: new Date().toISOString()
    });
});

// API health check
app.get('/api/health', (req, res) => {
    res.json({
        success: true,
        message: 'Person Management API is running',
        timestamp: new Date().toISOString()
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        success: false,
        message: 'Route not found'
    });
});

// Global error handler
app.use((error, req, res, next) => {
    console.error('Global error handler:', error);

    res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: process.env.NODE_ENV === 'development' ? error.message : 'Something went wrong'
    });
});

// Start server (only in development)
if (process.env.NODE_ENV !== 'production') {
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
        console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
        console.log(`MongoDB URI: ${process.env.MONGODB_URI}`);
        console.log(`Access the application at: http://localhost:${PORT}`);
    });
}

module.exports = app;
