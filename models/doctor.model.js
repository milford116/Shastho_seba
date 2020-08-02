const mongoose = require("mongoose");
const paginate = require("mongoose-paginate-v2");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     doctor:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *         designation:
 *           type: string
 *         institution:
 *           type: string
 *         reg_number:
 *           type: string
 *         mobile_no:
 *           type: string
 *           uniqueItems: true
 *         email:
 *           type: boolean
 *         session_token:
 *           type: string
 *         image:
 *           type: string
 *         referrer:
 *           type: string
 *         specialization:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/specialization'
 *       required:
 *         - name
 *         - designation
 *         - institution
 *         - reg_number
 *         - mobile_no
 *         - email
 *         - session_token
 *         - referrer
 *         - specialization
 */
var doctorSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},
	designation: {
		type: String,
		required: true,
	},
	institution: {
		type: String,
		required: true,
	},
	reg_number: {
		type: String,
		required: true,
	},
	mobile_no: {
		type: String,
		required: true,
		unique: true,
	},
	email: {
		type: String,
		required: true,
	},
	password: {
		type: String,
		required: true,
	},
	session_token: {
		type: String,
		required: false,
	},
	image: {
		type: String,
		required: false,
	},
	referrer: {
		type: String,
		required: true,
	},
	specialization: {
		type: Array,
		required: false,
	},
});

doctorSchema.plugin(paginate);
mongoose.model("doctor", doctorSchema);
