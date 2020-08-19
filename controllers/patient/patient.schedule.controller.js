const mongoose = require("mongoose");

const schedule = require("../../models/schedule.model");
const scheduleModel = mongoose.model("schedule");

const { SUCCESS, INTERNAL_SERVER_ERROR } = require("../../errors");
const error_message = require("../../error.messages");

/**
 * @swagger
 * /patient/get/schedule:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Schedule
 *     summary: gets the schedule of a doctor for the patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               mobile_no:
 *                 type: string
 *                 description: mobile number of the doctor
 *             required:
 *               - mobile_no
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 schedule:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/schedule'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.getSchedule = async function (req, res) {
	scheduleModel.find({ doc_mobile_no: req.body.mobile_no }, null, { sort: { day: 1, time_start: 1 } }, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				schedule: docs,
			};
			res.status(SUCCESS).send(ret);
		}
	});
};
