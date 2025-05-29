# Person Management RESTful API

A pure RESTful Web Service built with Node.js, Express, and MongoDB for managing people data. This backend serves as an API for the Angular frontend application.

## Features

- **Full CRUD Operations**: Create, Read, Update, Delete people
- **Pure REST API**: JSON-only API endpoints
- **MongoDB Integration**: Persistent data storage with sample data initialization
- **CORS Support**: Configured for Angular frontend integration
- **Input Validation**: Server-side validation with Mongoose
- **Error Handling**: Comprehensive JSON error responses

## API Endpoints

All endpoints return JSON responses and are prefixed with `/api/people`:

- `GET /api/people` - Get all people
- `POST /api/people` - Create a new person
- `GET /api/people/:id` - Get a specific person
- `PUT /api/people/:id` - Update a person
- `DELETE /api/people/:id` - Delete a person

Additional endpoints:
- `GET /` - API information
- `GET /api/health` - Health check

## Person Schema

```javascript
{
  name: String (required, min 2 chars),
  age: Number (required, 0-150),
  gender: String (required, enum: ['Male', 'Female', 'Other']),
  mobileNumber: String (required, valid phone format),
  createdAt: Date (auto-generated),
  updatedAt: Date (auto-generated)
}
```

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local installation or MongoDB Atlas)
- npm or yarn

## Installation

1. **Clone or navigate to the Backend directory**
   ```bash
   cd Backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   The `.env` file is already configured:
   ```env
   NODE_ENV=development
   MONGODB_URI=mongodb://localhost:27017/person_management
   PORT=3000
   FRONTEND_URL=http://localhost:4200
   ```

4. **Start MongoDB**
   - For local MongoDB: `mongod`
   - For MongoDB Atlas: Use your connection string in MONGODB_URI

5. **Run the application**
   ```bash
   # Development mode (with nodemon)
   npm run dev

   # Production mode
   npm start
   ```

6. **Access the application**
   - API Root: http://localhost:3000
   - API Health Check: http://localhost:3000/api/health
   - People API: http://localhost:3000/api/people

## Usage Examples

### API Usage (JSON)

**Get all people:**
```bash
curl http://localhost:3000/api/people
```

**Create a person:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "age": 30,
    "gender": "Male",
    "mobileNumber": "+1234567890"
  }' \
  http://localhost:3000/api/people
```

**Get a specific person:**
```bash
curl http://localhost:3000/api/people/PERSON_ID
```

**Update a person:**
```bash
curl -X PUT \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "age": 25,
    "gender": "Female",
    "mobileNumber": "+1987654321"
  }' \
  http://localhost:3000/api/people/PERSON_ID
```

**Delete a person:**
```bash
curl -X DELETE http://localhost:3000/api/people/PERSON_ID
```

## Project Structure

```
Backend/
├── config/
│   └── database.js          # MongoDB connection
├── models/
│   └── Person.js           # Person schema/model
├── routes/
│   └── personRoutes.js     # REST API routes
├── .env                    # Environment variables
├── package.json            # Dependencies
├── server.js              # Main server file
└── README.md              # This file
```

## Technologies Used

- **Backend**: Node.js, Express.js
- **Database**: MongoDB with Mongoose ODM
- **CORS**: Cross-Origin Resource Sharing for frontend integration
- **Validation**: Mongoose validators
- **Environment**: dotenv for configuration

## Error Handling

The application includes comprehensive error handling:
- MongoDB connection errors
- Validation errors (required fields, age range, etc.)
- 404 errors for non-existent resources
- 500 errors for server issues
- Consistent JSON error responses for all API calls

## Sample Data

The API automatically initializes with sample data when the database is empty:
- John Doe (Male, 30, +1234567890)
- Jane Smith (Female, 25, +1987654321)
- Alex Johnson (Other, 35, +1122334455)

## Development

For development with auto-restart:
```bash
npm run dev
```

This uses nodemon to automatically restart the server when files change.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

ISC License
