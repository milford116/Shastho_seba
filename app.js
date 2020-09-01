const express = require("express");
const app = express();
const https = require("https");
const fs = require("fs");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const swagger = require("./util/swaggerSpec");
const cors = require("cors");
const medicine = require("./controllers/doctor/doctor.medicine.controller");
dotenv.config();

const doctorRoutes = require("./routes/doctor");
const patientRoutes = require("./routes/patient");

mongoose.set("useCreateIndex", true);

const options = {
	useUnifiedTopology: true,
	useNewUrlParser: true,
};

mongoose.connect(process.env.DB_URL, options, (err) => {
	if (!err) {
		console.log("Successfully connected to database");
	} else {
		console.log("Error occurred during database connection");
	}
});

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.json());

// set the docs
swagger(app);

app.use(express.static("storage"));
app.use(doctorRoutes);
app.use(patientRoutes);

const httpsOptions = {
	key: fs.readFileSync("./certificates/key.pem"),
	cert: fs.readFileSync("./certificates/cert.pem"),
};

const server = https.createServer(httpsOptions, app);
server.listen(process.env.PORT, () => console.log("https server started at port ", process.env.PORT));

// const server = app.listen(process.env.PORT, () => {
// 	medicine.populateMedicine();
// 	console.log("Server started at port " + process.env.PORT);
// });

const chamber = require("./chamber");
chamber.handleSocketIO(server);
