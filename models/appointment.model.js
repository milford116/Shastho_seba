const mongoose = require("mongoose");
mongoose.pluralize(null);

var appointmentSchema = new mongoose.Schema({
	doc_mobile_no: {
		type: String,
		required: true,
	},
	doc_name: {
		type: String,
		required: true,
	},
	patient_mobile_no: {
		type: String,
		required: true,
	},
	status: {
		type: Boolean,
		required: true,
	},
	prescription_img: {
		type: String,
		required: false,
	},
	appointment_date: {
		type: Date,
		required: true,
	},
});

mongoose.model("appointment", appointmentSchema);
