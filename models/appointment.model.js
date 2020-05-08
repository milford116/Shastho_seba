const mongoose = require("mongoose");
mongoose.pluralize(null);

var appointmentSchema = new mongoose.Schema({
	serial_no: {
		type: Number,
		required: true,
	},
	schedule_id: {
		type: String,
		required: true,
	},
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
		type: Number,
		required: true,
	},
	prescription_img: {
		type: String,
		required: false,
	},
	appointment_date_time: {
		type: Date,
		required: true,
	},
});

mongoose.model("appointment", appointmentSchema);
