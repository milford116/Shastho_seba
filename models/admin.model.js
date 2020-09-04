const mongoose = require("mongoose");
const paginate = require("mongoose-paginate-v2");
const bcrypt = require("bcryptjs");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     admin:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *         phone:
 *           type: string
 *         password:
 *           type: string
 *         session_token:
 *           type: string
 *       required:
 *         - name
 *         - phone
 *         - password
 */
var adminSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},
	phone: {
		type: String,
		required: true,
		unique: true,
	},
	password: {
		type: String,
		required: true,
	},
	session_token: {
		type: String,
		required: false,
	},
});

adminSchema.pre("save", async function (next) {
	try {
		const salt = await bcrypt.genSalt(parseInt(process.env.SALT_ROUNDS, 10));
		const passwordHash = await bcrypt.hash(this.password, salt);
		this.password = passwordHash;
		next();
	} catch (error) {
		next(error);
	}
});

adminSchema.plugin(paginate);
mongoose.model("admin", adminSchema);
