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
	date_of_birth: {
		type: Date,
		required: true,
	},
	sex: {
		type: String,
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
