const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     schedule:
 *       type: object
 *       properties:
 *         doc_mobile_no:
 *           type: string
 *         day:
 *           type: number
 *         fee:
 *           type: number
 *         time_start:
 *           type: string
 *           format: date-time
 *           default: current-date
 *         time_end:
 *           type: string
 *           format: date-time
 *           default: current-date
 *       required:
 *         - doc_mobile_no
 *         - time_start
 *         - time_end
 *         - day
 *         - fee
 */
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
		type: Number,
		required: true,
	},
	fee: {
		type: Number,
		required: true,
	},
});

mongoose.model("schedule", scheduleSchema);
