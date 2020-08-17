const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     timeline:
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
var timelineSchema = new mongoose.Schema(
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
	{ timestamps: true }
);

mongoose.model("timeline", timelineSchema);
