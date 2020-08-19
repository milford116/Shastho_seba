const mongoose = require("mongoose");
const feedback = require("../../models/feedback.model");
const feedbackModel = mongoose.model("feedback");
const error_message = require("../../error.messages");
const {SUCCESS, INTERNAL_SERVER_ERROR} = require("../../errors");

/**
 * @swagger
 * /patient/post/feedback:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - feedback
 *     summary: feedback of a patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               feedback:
 *                 type: string
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.postFeedback = async function (req, res) {
	let new_feedback = new feedbackModel();
	new_feedback.feedback = req.body.feedback;
	new_feedback.type = req.type;
	new_feedback.mobile_no = req.mobile_no;

	new_feedback.save((err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).json(error_message.SUCCESS);
		}
	});
};
