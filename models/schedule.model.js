const mongoose = require("mongoose");
mongoose.pluralize(null);

var scheduleSchema = new mongoose.Schema({
	doc_mobile_no: {
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
	day: {
		type: String,
		required: true,
	},
	fee: {
		type: Number,
		required: true,
	},
});

mongoose.model("schedule", scheduleSchema);
