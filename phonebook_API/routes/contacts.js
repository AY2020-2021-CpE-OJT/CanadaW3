const express = require('express');
const router = express.Router();
const Contact = require('../models/contact');

//CRUD
//Get all
router.get('/', async (req, res) => {
    const contacts = await Contact.find();
    res.json(contacts);
});
//Get specific
router.get('/find/:id', async (req, res) => {
    const c = await Contact.findById({_id: req.params.id});
    res.json(c);
});
//POST a Contact
router.post('/', async (req, res) => {
    const newContact = new Contact({
        last_name: req.body.last_name,
        first_name: req.body.first_name,
        phone_numbers: req.body.phone_numbers
    })
    try{
        const savedContact = await newContact.save();
        res.json(savedContact);
    }catch(err){
        res.json({message: err});
    }
});
//Delete a Contact
router.delete('/delete/:id', async (req, res) =>{
   const deleteContact = await Contact.findByIdAndDelete({_id: req.params.id});
   res.json(deleteContact); 
});
//Update a Contact
router.patch('/update/:id', async (req, res) => {
    const patchContact = await Contact.updateOne({_id: req.params.id}, {$set: req.body});
    res.json(patchContact);
});

module.exports = router;
