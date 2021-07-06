const express = require('express');
const app = express();
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const mongoConfig = require('./mongoConfig');

//body-parser and cors
app.use(bodyParser.json());

//import routes
const contactsRoutes = require('./routes/contacts');
app.use('/contacts', contactsRoutes);

//home
app.get('/', (req,res) => {
    res.send('Hello World');
})
app.get('/dashboard', (req, res) => {
    res.send('Dashboard');
})

//connect to mongoDB
mongoose.connect(mongoConfig.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        }).then(() => console.log(`MongoDB Connected`)).catch(err => console.log(err));

//listen to port
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running at port ${PORT}`));
