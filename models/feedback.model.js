const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     feedback:
 *       type: object
 *       properties:
 *         mobile_no:
 *           type: string
 *           descriptions: whoever is giving feedback
 *         type:
 *           type: string
 *           descriptions: who is giving feedback? doctor or patient
 *         feedback:
 *           type: string
 *           description: the feedback of the user
 *       required:
 *         - mobile_no
 *         - type
 *         - feedback
 */
var feedbackSchema = new mongoose.Schema(
	{
		mobile_no: {
			type: String,
			required: true,
		},
		type: {
			type: String,
			required: true,
		},
		feedback: {
			type: String,
			require: true,
		},
	},
	{timestamps: true}
);

mongoose.model("feedback", feedbackSchema);
