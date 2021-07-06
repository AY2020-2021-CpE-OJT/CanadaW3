const mongoose = require('mongoose');

const contactSchema = new mongoose.Schema({
    last_name: {
        type: String,
        required: true
    },
    first_name: {
        type: String,
        required: true
    },
    phone_numbers: {
        type: [String],
    }
});
module.exports = mongoose.model('Contacts', contactSchema)