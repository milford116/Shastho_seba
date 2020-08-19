const mongoose = require("mongoose");
mongoose.pluralize(null);
const schema = mongoose.Schema;

/**
 * @swagger
 * components:
 *   schemas:
 *     patient:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *         mobile_no:
 *           type: string
 *           uniqueItems: true
 *         password:
 *           type: string
 *         date_of_birth:
 *           type: string
 *         sex:
 *           type: string
 *         session_token:
 *           type: string
 *         image_link:
 *           type: string
 *         registration_token:
 *           type: string
 *       required:
 *         - name
 *         - mobile_no
 *         - date_of_birth
 *         - sex
 */
var patientSchema = new mongoose.Schema({
	mobile_no: {
		type: String,
		required: true,
		unique: true,
	},
	name: {
		type: String,
		required: true,
	},
	password: {
		type: String,
		required: true,
	},
	date_of_birth: {
		type: Date,
		required: true,
	},
	sex: {
		type: String,
		required: true,
	},
	session_token: {
		type: String,
		required: false,
	},
	image_link: {
		type: String,
		required: false,
	},
	registration_token: {
		type: String,
		required: false,
	},
});

mongoose.model("patient", patientSchema);
