const mongoose = require("mongoose");
mongoose.pluralize(null);

var referenceSchema = new mongoose.Schema({
	referrer: {
		type: String,
		required: true,
	},
	doctor: {
		type: String,
		required: true,
	},
});

mongoose.model("reference", referenceSchema);
