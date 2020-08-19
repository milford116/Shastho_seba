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
	type: {
		type: Number,
		required: true,
	},
	type_id: {
		type: String,
		required: true,
	},
	appointment_date: {
		type: Date,
		required: false,
	},
},
	{ timestamps: true }
);

mongoose.model("timeline", timelineSchema);

/*
type:
	0 - appointment
	1 - transaction
	2 - prescription
*/