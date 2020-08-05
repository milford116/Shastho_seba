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
 *               id:
 *                 type: string
 *               registration_token:
 *                 type: string
 *             required:
 *               - id
 *               - registration_token
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 */
exports.setToken = async function (req, res) {
	patientModel.updateOne({_id: req.body.id}, {registration_token: req.body.registration_token}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json({msg: error_message.INTERNAL_SERVER_ERROR});
		else res.status(SUCCESS).json({msg: error_message.SUCCESS});
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
 *                 msg:
 *                   type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 */
exports.getToken = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json({msg: error_message.INTERNAL_SERVER_ERROR});
		else {
			let ret = {
				msg: error_message.SUCCESS,
				registration_token: docs.registration_token,
			};

			res.status(SUCCESS).json(ret);
		}
	});
};
