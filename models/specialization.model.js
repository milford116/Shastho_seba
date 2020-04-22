const mongoose = require("mongoose");
mongoose.pluralize(null);

var specializationSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},
});

mongoose.model("specialization", specializationSchema);
