const mongoose = require("mongoose");
mongoose.pluralize(null);

var transactionSchema = new mongoose.Schema({
	txn_id: {
		type: String,
		required: true,
	},

	appointment_id: {
		type: String,
		required: true,
	},

	amount: {
		type: Number,
		required: true,
	},
});

mongoose.model("transaction", transactionSchema);
