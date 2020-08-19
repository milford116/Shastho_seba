const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     timeline:
 *       type: object
 *       properties:
 *         doctor_mobile_no:
 *           type: string
 *         patient_mobile_no:
 *           type: string
 *         type_id:
 *           type: string
 *         type:
 *           type: string
 *         appointment_date:
 *           type: String
 *           format: date-format
 *         createdAt:
 *           type: string
 *           format: date-format
 *       required:
 *         - doctor_mobile_no
 *         - patient_mobile_no
 *         - type
 *         - type_id
 */
var timelineSchema = new mongoose.Schema({
	doctor_mobile_no: {
		type: String,
		required: true,
	},
	patient_mobile_no: {
		type: String,
		required: true,
	},
	appointment_id: {
		type: String,
		required: true,
	},
	appointment_date: {
		type: Date,
		required: true,
	},
	appointment_createdAt: {
		type: Date,
		required: true,
	},
	transaction_id: {
		type: String,
		required: false,
	},
	transaction_createdAt: {
		type: String,
		required: false,
	},
	prescription_createdAt: {
		type: String,
		required: false,
	},
});

mongoose.model("timeline", timelineSchema);