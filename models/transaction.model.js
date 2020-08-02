const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     transaction:
 *       type: object
 *       properties:
 *         appointment_id:
 *           type: string
 *         transaction_id:
 *           type: string
 *         amount:
 *           type: number
 *       required:
 *         - appointment_id
 *         - transaction_id
 *         - amount
 */
var transactionSchema = new mongoose.Schema({
	appointment_id: {
		type: String,
		required: true,
	},
	transaction_id: {
		type: String,
		required: true,
	},
	amount: {
		type: Number,
		required: true,
	},
});

mongoose.model("transaction", transactionSchema);
