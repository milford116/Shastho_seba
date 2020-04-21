const mongoose = require('mongoose');
mongoose.pluralize(null);

var doctorSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},

	designation: {
		type: String,
		required: true,
	},

	institution: {
		type: String,
		required: true,
	},

	reg_number: {
		type: String,
		required: true,
	},

	mobile_no: {
		type: String,
		required: true,
		unique: true,
	},

	email: {
		type: String,
		required: true,
	},

	password: {
		type: String,
		required: true,
	},

	session_token: {
		type: String,
		required: true,
	},

	image: {
		type: String,
		required: false,
	},
});

mongoose.model('doctor', doctorSchema);
