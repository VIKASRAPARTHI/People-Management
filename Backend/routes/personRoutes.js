const express = require('express');
const router = express.Router();
const Person = require('../models/Person');

// In-memory data store (fallback when MongoDB is not available)
let inMemoryPeople = [];
let nextId = 1;
let useInMemory = false;

// Sample data for initial load
const samplePeople = [
    {
        name: 'John Doe',
        age: 30,
        gender: 'Male',
        mobileNumber: '+1234567890'
    },
    {
        name: 'Jane Smith',
        age: 25,
        gender: 'Female',
        mobileNumber: '+1987654321'
    },
    {
        name: 'Alex Johnson',
        age: 35,
        gender: 'Other',
        mobileNumber: '+1122334455'
    }
];

// Initialize sample data if collection is empty
const initializeSampleData = async () => {
    try {
        if (useInMemory) {
            if (inMemoryPeople.length === 0) {
                inMemoryPeople = samplePeople.map(person => ({
                    ...person,
                    id: nextId++,
                    _id: nextId - 1,
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString()
                }));
                console.log('Sample data initialized (in-memory)');
            }
        } else {
            const count = await Person.countDocuments();
            if (count === 0) {
                await Person.insertMany(samplePeople);
                console.log('Sample data initialized (MongoDB)');
            }
        }
    } catch (error) {
        console.error('Error initializing sample data, switching to in-memory mode:', error);
        useInMemory = true;
        if (inMemoryPeople.length === 0) {
            inMemoryPeople = samplePeople.map(person => ({
                ...person,
                id: nextId++,
                _id: nextId - 1,
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString()
            }));
            console.log('Sample data initialized (in-memory fallback)');
        }
    }
};

// GET /api/people - Get all people
router.get('/', async (req, res) => {
    try {
        // Initialize sample data if needed
        await initializeSampleData();

        let people;
        if (useInMemory) {
            people = [...inMemoryPeople].sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
        } else {
            people = await Person.find().sort({ createdAt: -1 });
        }

        res.json({
            success: true,
            data: people,
            count: people.length
        });
    } catch (error) {
        console.error('Error fetching people:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching people',
            error: error.message
        });
    }
});

// POST /api/people - Create a new person
router.post('/', async (req, res) => {
    try {
        const { name, age, gender, mobileNumber } = req.body;

        let savedPerson;
        if (useInMemory) {
            savedPerson = {
                id: nextId,
                _id: nextId,
                name,
                age: parseInt(age),
                gender,
                mobileNumber,
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString()
            };
            inMemoryPeople.push(savedPerson);
            nextId++;
        } else {
            const newPerson = new Person({
                name,
                age: parseInt(age),
                gender,
                mobileNumber
            });
            savedPerson = await newPerson.save();
        }

        res.status(201).json({
            success: true,
            data: savedPerson,
            message: 'Person created successfully'
        });
    } catch (error) {
        console.error('Error creating person:', error);
        res.status(400).json({
            success: false,
            message: 'Error creating person',
            error: error.message
        });
    }
});

// GET /api/people/:id - Get a specific person
router.get('/:id', async (req, res) => {
    try {
        let person;
        if (useInMemory) {
            person = inMemoryPeople.find(p => p.id == req.params.id || p._id == req.params.id);
        } else {
            person = await Person.findById(req.params.id);
        }

        if (!person) {
            return res.status(404).json({
                success: false,
                message: 'Person not found'
            });
        }

        res.json({
            success: true,
            data: person
        });
    } catch (error) {
        console.error('Error fetching person:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching person',
            error: error.message
        });
    }
});

// PUT /api/people/:id - Update a person
router.put('/:id', async (req, res) => {
    try {
        const { name, age, gender, mobileNumber } = req.body;

        const updateData = {
            name,
            age: parseInt(age),
            gender,
            mobileNumber
        };

        let updatedPerson;
        if (useInMemory) {
            const index = inMemoryPeople.findIndex(p => p.id == req.params.id || p._id == req.params.id);
            if (index === -1) {
                return res.status(404).json({
                    success: false,
                    message: 'Person not found'
                });
            }
            inMemoryPeople[index] = {
                ...inMemoryPeople[index],
                ...updateData,
                updatedAt: new Date().toISOString()
            };
            updatedPerson = inMemoryPeople[index];
        } else {
            updatedPerson = await Person.findByIdAndUpdate(
                req.params.id,
                updateData,
                { new: true, runValidators: true }
            );
            if (!updatedPerson) {
                return res.status(404).json({
                    success: false,
                    message: 'Person not found'
                });
            }
        }

        res.json({
            success: true,
            data: updatedPerson,
            message: 'Person updated successfully'
        });
    } catch (error) {
        console.error('Error updating person:', error);
        res.status(400).json({
            success: false,
            message: 'Error updating person',
            error: error.message
        });
    }
});

// DELETE /api/people/:id - Delete a person
router.delete('/:id', async (req, res) => {
    try {
        let deletedPerson;
        if (useInMemory) {
            const index = inMemoryPeople.findIndex(p => p.id == req.params.id || p._id == req.params.id);
            if (index === -1) {
                return res.status(404).json({
                    success: false,
                    message: 'Person not found'
                });
            }
            deletedPerson = inMemoryPeople[index];
            inMemoryPeople.splice(index, 1);
        } else {
            deletedPerson = await Person.findByIdAndDelete(req.params.id);
            if (!deletedPerson) {
                return res.status(404).json({
                    success: false,
                    message: 'Person not found'
                });
            }
        }

        res.json({
            success: true,
            message: 'Person deleted successfully',
            data: deletedPerson
        });
    } catch (error) {
        console.error('Error deleting person:', error);
        res.status(500).json({
            success: false,
            message: 'Error deleting person',
            error: error.message
        });
    }
});

module.exports = router;
