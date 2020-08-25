const mongoose = require("mongoose");
const timeline = require("../../models/timeline.model");
const timelineModel = mongoose.model("timeline");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../../errors");
const error_message = require("../../error.messages");

/**
 * @swagger
 * /patient/get/timeline:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Timeline
 *     summary: timeline of a pair of doctor-patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               patient_mobile_no:
 *                 type: string
 *                 description: send this from the doctor app
 *               doctor_mobile_no:
 *                 type: string
 *                 description: send this from the patient app
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 timeline:
 *                   type: array
 *                   $ref: '#/components/schemas/timeline'
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

exports.getTimeline = async function (req, res) {
	let query = {
		doctor_mobile_no: req.body.doctor_mobile_no,
		patient_mobile_no: req.mobile_no,
	};

	timelineModel.find(query, null, {sort: {appointment_date: 1}}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let timeline = docs;
			res.status(SUCCESS).json({timeline});
		}
	});
};
