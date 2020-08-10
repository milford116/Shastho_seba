const mongoose = require("mongoose");

const patient = require("../models/patient.model");
const patientModel = mongoose.model("patient");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

/**
 * @swagger
 * /patient/set/token:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Token
 *     summary: don't know why i wrote it
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               registration_token:
 *                 type: string
 *             required:
 *               - registration_token
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 registration_token:
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
exports.setToken = async function (req, res) {
	patientModel.findOneAndUpdate({mobile_no: req.mobile_no}, {registration_token: req.body.registration_token}, {new: true}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else {
			res.status(SUCCESS).json({registration_token: docs.registration_token});
		}
	});
};

/**
 * @swagger
 * /doctor/get/token:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Token
 *     summary: forgot why i wrote this
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               mobile_no:
 *                 type: string
 *                 description: mobile number of the patient
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
 *                 registration_token:
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
exports.getToken = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else {
			let ret = {
				registration_token: docs.registration_token,
			};

			res.status(SUCCESS).json(ret);
		}
	});
};
