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
 *         doctorId:
 *           $ref: '#/components/schemas/doctor'
 *         patientId:
 *           $ref: '#/components/schemas/patient'
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
var appointmentSchema = new mongoose.Schema(
	{
		serial_no: {
			type: Number,
			required: true,
		},
		schedule_id: {
			type: mongoose.Schema.Types.ObjectId,
			required: true,
			ref: "schedule",
		},
		doctorId: {
			type: mongoose.Schema.Types.ObjectId,
			required: true,
			ref: "doctor",
		},
		patientId: {
			type: mongoose.Schema.Types.ObjectId,
			required: true,
			ref: "patient",
		},
		status: {
			type: Number,
			required: true,
			default: 0,
		},
		due: {
			type: Number,
			required: false,
		},
		prescription_img: {
			type: String,
			required: false,
		},
		appointment_date_time: {
			type: Date,
			required: true,
		},
	},
	{ timestamps: true }
);

mongoose.model("appointment", appointmentSchema);
