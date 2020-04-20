const express = require('express');
const app = express();
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const cors = require('cors');
dotenv.config();

mongoose.set('useCreateIndex', true);

const options = {
	useUnifiedTopology: true,
	useNewUrlParser: true,
};

// const payload = {
//     name: "Imran",
//     pass: "123456"
// }

mongoose.connect(process.env.DB_URL, options, (err) => {
	if (!err) console.log('Successfully connected to database');
	else console.log('Error occurred during database connection');
});

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

//add your route here
var doctor = require('routes/doctor.js');
app.use('/doctor', doctor);

// app.get("/token", (req, res)=>{
//     const token = jwt.sign(payload, process.env.SECRET);
//     res.send(token);
// });

app.listen(process.env.PORT, () => {
	console.log('Server started at port ' + process.env.PORT);
});
