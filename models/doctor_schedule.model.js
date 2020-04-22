const mongoose = require("mongoose");
mongoose.pluralize(null);

var doctor_scheduleSchema = new mongoose.Schema({
	doctor_id: {
		type: String,
		required: true,
	},

	time_start: {
		type: Date,
		required: true,
	},

	time_end: {
		type: Date,
		required: true,
	},

	days: {
		type: Array,
		required: true,
	},

	fee: {
		type: Number,
		required: true,
	},
});

mongoose.model("doctor_schedule", doctor_scheduleSchema);
