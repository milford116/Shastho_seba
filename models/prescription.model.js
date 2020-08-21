const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     prescription:
 *       type: object
 *       properties:
 *         appointment_id:
 *           type: string
 *         prescription_img:
 *           type: string
 *         patient_name:
 *           type: string
 *         patient_age:
 *           type: number
 *         patient_sex:
 *           type: string
 *         medicine:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               dose:
 *                 type: number
 *               date:
 *                 type: string
 *       required:
 *         - appointment_id
 *         - patient_name
 *         - patient_age
 *         - patient_sex
 */
var prescriptionSchema = new mongoose.Schema({
	appointment_id: {
		type: String,
		required: true,
	},
	prescription_img: {
		type: String,
		required: false,
	},
	patient_name: {
		type: String,
		required: true,
	},
	patient_age: {
		type: Number,
		required: true,
	},
	patient_sex: {
		type: String,
		required: true,
	},
	medicine: [
		{
			name: {
				type: String,
				required: true,
			},

			dose: {
				type: String,
				required: true,
			},
			date: {
				type: String,
				required: true,
			},
		},
	],
});

mongoose.model("prescription", prescriptionSchema);
