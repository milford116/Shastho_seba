const mongoose = require("mongoose");
mongoose.pluralize(null);
const schema = mongoose.Schema;

var patientSchema = new mongoose.Schema({
	mobile_no: {
		type: String,
		required: true,
		unique: true,
	},
	name: {
		type: String,
		required: true,
	},
	password: {
		type: String,
		required: true,
	},
	age: {
		type: Number,
		required: true,
	},
	session_token: {
		type: String,
		required: false,
	},
	image_link: {
		type: String,
		required: false,
	},
});

mongoose.model("patient", patientSchema);
