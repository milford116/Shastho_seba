const mongoose = require("mongoose");
const prescription = require("../../models/prescription.model");
const prescriptionModel = mongoose.model("prescription");
const error_message = require("../../error.messages");
const {SUCCESS, INTERNAL_SERVER_ERROR} = require("../../errors");

/**
 * @swagger
 * /patient/get/prescription:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Prescription
 *     summary: Gets prescription
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               appointment_id:
 *                 type: string
 *             required:
 *               - appointment_id
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 prescription:
 *                   $ref: '#/components/schemas/prescription'
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
exports.getPrescription = async function (req, res) {
	prescriptionModel.find({appointment_id: req.body.appointment_id}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				prescription: docs,
			};

			res.status(SUCCESS).json(ret);
		}
	});
};
