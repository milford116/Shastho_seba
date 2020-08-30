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
 *           type: string
 *         patient_sex:
 *           type: string
 *         patient_weight:
 *           type: string
 *         patient_bp:
 *           type: string
 *         patient_temperature:
 *           type: string
 *         patient_blood_sugar:
 *           type: string
 *         patient_pulse_count:
 *           type: string
 *         symptoms:
 *           type: array
 *           items:
 *             type: string
 *         tests:
 *           type: array
 *           items:
 *             type: string
 *         special_advice:
 *           type: array
 *           items:
 *             type: string
 *         medicine:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               dose:
 *                 type: string
 *               direction:
 *                 type: string
 *                 description: whether to use the med before/after having food or use the oinments after/before bath
 *               day:
 *                 type: string
 *       required:
 *         - appointment_id
 *         - patient_name
 *         - patient_age
 *         - patient_sex
 *         - symptoms
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
		type: String,
		required: true,
	},
	patient_sex: {
		type: String,
		required: true,
	},
	patient_weight: {
		type: String,
		required: false,
	},
	patient_bp: {
		type: String,
		required: false,
	},
	patient_temperature: {
		type: String,
		required: false,
	},
	patient_pulse_count: {
		type: String,
		required: false,
	},
	patient_blood_sugar: {
		type: String,
		required: false,
	},
	symptoms: [
		{
			type: String,
			required: true,
		},
	],
	tests: [
		{
			type: String,
			required: false,
		},
	],
	special_advice: [
		{
			type: String,
			required: false,
		},
	],
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

			direction: {
				type: String,
				required: true,
			},

			day: {
				type: String,
				required: true,
			},
		},
	],
});

mongoose.model("prescription", prescriptionSchema);
