const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     appointment:
 *       type: object
 *       properties:
 *         serial_no:
 *           type: string
 *         schedule_id:
 *           type: string
 *         doc_mobile_no:
 *           type: string
 *         doc_name:
 *           type: string
 *         patient_mobile_no:
 *           type: string
 *         patient_name:
 *           type: string
 *         status:
 *           type: number
 *           default: 0
 *         prescription_img:
 *           type: string
 *         appointment_date_time:
 *           type: string
 *           format: date-time
 *       required:
 *         - serial_no
 *         - schedule_id
 *         - doc_mobile_no
 *         - doc_name
 *         - patient_mobile_no
 *         - status
 *         - appointment_date_time
 */
var appointmentSchema = new mongoose.Schema({
	serial_no: {
		type: Number,
		required: true,
	},
	schedule_id: {
		type: String,
		required: true,
	},
	doc_mobile_no: {
		type: String,
		required: true,
	},
	doc_name: {
		type: String,
		required: true,
	},
	patient_mobile_no: {
		type: String,
		required: true,
	},
	patient_name: {
		type: String,
		required: true,
	},
	status: {
		type: Number,
		required: true,
		default: 0,
	},
	prescription_img: {
		type: String,
		required: false,
	},
	appointment_date_time: {
		type: Date,
		required: true,
	},
});

mongoose.model("appointment", appointmentSchema);
