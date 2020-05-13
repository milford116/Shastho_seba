const mongoose = require("mongoose");
mongoose.pluralize(null);

var prescriptionSchema = new mongoose.Schema({
	appointment_id: {
		type: String,
		required: true,
	},

	prescription_img: {
		type: String,
		required: false,
	},

	medicine: {
		type: Array,
		required: false,
	},
});

mongoose.model("prescription", prescriptionSchema);
