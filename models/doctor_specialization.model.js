const mongoose = require("mongoose");
mongoose.pluralize(null);

var doctor_specializationSchema = new mongoose.Schema({
	doctor_id: {
		type: String,
		required: true,
	},

	specialization_id: {
		type: Array,
		required: true,
	},
});

mongoose.model("doctor_specialization", doctor_specializationSchema);
