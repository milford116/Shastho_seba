const mongoose = require("mongoose");
mongoose.pluralize(null);

var transactionSchema = new mongoose.Schema({
	appointment_id: {
		type: ObjectId,
		required: true,
	},
	amount: {
		type: Number,
		required: true,
	},
});

mongoose.model("transaction", transactionSchema);
