const express = require('express');
const app = express();
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const cors = require('cors');
dotenv.config();

const doctorRoutes = require('./routes/doctor');
const patientRoutes = require('./routes/patient');

mongoose.set("useCreateIndex", true);

const options = {
<<<<<<< HEAD
    useUnifiedTopology: true,
    useNewUrlParser: true,
};

mongoose.connect(process.env.DB_URL, options, (err) => {
    if (!err) console.log("Successfully connected to database");
    else console.log("Error occurred during database connection");
=======
	useUnifiedTopology: true,
	useNewUrlParser: true,
};

mongoose.connect(process.env.DB_URL, options, (err) => {
	if (!err) console.log('Successfully connected to database');
	else console.log('Error occurred during database connection');
>>>>>>> 5fece5a12ecca515dcb123ee6dff432bc387cba9
});

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

//add your route here
app.use(doctorRoutes);
app.use(patientRoutes);

app.listen(process.env.PORT, () => {
<<<<<<< HEAD
    console.log("Server started at port " + process.env.PORT);
=======
	console.log('Server started at port ' + process.env.PORT);
>>>>>>> 5fece5a12ecca515dcb123ee6dff432bc387cba9
});
