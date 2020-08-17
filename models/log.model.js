const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     log:
 *       type: object
 *       properties:
 *         appointment_id:
 *           type: string
 *         type:
 *           type: number
 *         createdAt:
 *           type: string
 *           format: date-format
 *       required:
 *         - doctor_mobile_no
 *         - patient_mobile_no
 *         - type
 */
var logSchema = new mongoose.Schema(
	{
		appointment_id: {
			type: String,
			required: true,
		},
		type: {
			type: String,
			required: true,
		},
	},
	{timestamps: true}
);

mongoose.model("log", logSchema);
