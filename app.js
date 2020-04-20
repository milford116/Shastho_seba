const express = require("express");
const app = express();
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const jwt = require("jsonwebtoken");
const cors = require("cors");
dotenv.config();
const patientRoutes = require("./routes/patient");

mongoose.set('useCreateIndex', true);

const options = {
    useUnifiedTopology: true, 
    useNewUrlParser: true
}

mongoose.connect(process.env.DB_URL, options, (err)=>{
    if (!err)
        console.log("Successfully connected to database");
    else
        console.log("Error occurred during database connection");
});

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

//add your route here
app.use(patientRoutes);

app.listen(process.env.PORT, ()=>
{
    console.log("Server started at port " + process.env.PORT);
});