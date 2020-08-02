const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     reference:
 *       type: object
 *       properties:
 *         referrer:
 *           type: string
 *           descriptions: whoever is referring
 *         doctor:
 *           type: string
 *           descriptions: who is being referred
 *       required:
 *         - referrer
 *         - doctor
 */
var referenceSchema = new mongoose.Schema({
	referrer: {
		type: String,
		required: true,
	},
	doctor: {
		type: String,
		required: true,
	},
});

mongoose.model("reference", referenceSchema);
