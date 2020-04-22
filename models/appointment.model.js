const mongoose = require("mongoose");
mongoose.pluralize(null);

var appointmentSchema = new mongoose.Schema({
	doctor_id: {
		type: String,
		required: true,
	},

	patient_id: {
		type: String,
		required: true,
	},

	status: {
		type: Boolean,
		required: true,
	},

	prescription_img: {
		type: String,
		required: true,
	},

	appointment_time: {
		type: Date,
		required: true,
	},

	appointment_date: {
		type: Date,
		required: true,
	},
});

mongoose.model("appointment", appointmentSchema);
