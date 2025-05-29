const mongoose = require('mongoose');

const personSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Name is required'],
        trim: true,
        minlength: [2, 'Name must be at least 2 characters long']
    },
    age: {
        type: Number,
        required: [true, 'Age is required'],
        min: [0, 'Age must be a positive number'],
        max: [150, 'Age must be less than 150']
    },
    gender: {
        type: String,
        required: [true, 'Gender is required'],
        enum: {
            values: ['Male', 'Female', 'Other'],
            message: 'Gender must be Male, Female, or Other'
        }
    },
    mobileNumber: {
        type: String,
        required: [true, 'Mobile number is required'],
        trim: true,
        match: [/^[\+]?[1-9][\d]{9,14}$/, 'Please enter a valid mobile number']
    }
}, {
    timestamps: true // This automatically adds createdAt and updatedAt fields
});

// Virtual for display name (same as name field)
personSchema.virtual('displayName').get(function() {
    return this.name;
});

// Ensure virtual fields are serialized
personSchema.set('toJSON', {
    virtuals: true
});

module.exports = mongoose.model('Person', personSchema);
