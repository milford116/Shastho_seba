const mongoose = require("mongoose");
mongoose.pluralize(null);

/**
 * @swagger
 * components:
 *   schemas:
 *     specialization:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *       required:
 *         - name
 */
var specializationSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},
});

mongoose.model("specialization", specializationSchema);
