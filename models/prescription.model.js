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
 *         medicine:
 *           type: array
 *           items:
 *             type: string
 *       required:
 *         - appointment_id
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
	medicine: {
		type: Array,
		required: false,
	},
});

mongoose.model("prescription", prescriptionSchema);
