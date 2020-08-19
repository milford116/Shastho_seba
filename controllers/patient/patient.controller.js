const mongoose = require("mongoose");
mongoose.set("useFindAndModify", false);
const patient = require("../../models/patient.model");
const patientModel = mongoose.model("patient");

const bcrypt = require("bcryptjs");
const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND } = require("../../errors");
const error_message = require("../../error.messages");

/**
 * @swagger
 * /patient/post/register:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Patient
 *     summary: registration of patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               date_of_birth:
 *                 type: string
 *                 format: date-time
 *               mobile_no:
 *                 type: string
 *               name:
 *                 type: string
 *               sex:
 *                 type: string
 *               password:
 *                 type: string
 *             required:
 *               - date_of_birth
 *               - mobile_no
 *               - name
 *               - sex
 *               - password
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
exports.registration = async function (req, res) {
	patientModel.findOne({ mobile_no: req.body.mobile_no }, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			//var dob = new Date(req.body.date_of_birth);
			//dob.setHours(dob.getHours() + 6);
			var new_patient = new patientModel();
			new_patient.mobile_no = req.body.mobile_no;
			new_patient.name = req.body.name;
			new_patient.date_of_birth = req.body.date_of_birth;
			new_patient.sex = req.body.sex;

			bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else {
					new_patient.password = hash;

					new_patient.save((err, doc) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							res.status(SUCCESS).json(error_message.SUCCESS);
						}
					});
				}
			});
		}
	});
};

/**
 * @swagger
 * /patient/post/login:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Patient
 *     summary: logs in an patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               mobile_no:
 *                 type: string
 *               password:
 *                 type: string
 *             required:
 *               - mobile_no
 *               - password
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   description: jwt token
 *                 patient:
 *                   $ref: '#/components/schemas/patient'
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
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       404:
 *         description: Data Not Found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.login = async function (req, res) {
	patientModel.findOne({ mobile_no: req.body.mobile_no }, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else if (!result) {
					res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
				} else {
					const payload = {
						mobile_no: req.body.mobile_no,
						name: docs.name,
						age: docs.age,
					};

					const token_value = jwt.sign(payload, process.env.SECRET);
					const ret = {
						token: token_value,
					};

					patientModel.findOneAndUpdate({ mobile_no: req.body.mobile_no }, { session_token: token_value }, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							ret.patient = docs;
							res.status(SUCCESS).json(ret);
						}
					});
				}
			});
		}
	});
};

/**
 * @swagger
 * /patient/get/details:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Patient
 *     summary: Details of patient
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 patient:
 *                   $ref: '#/components/schemas/patient'
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
exports.details = async function (req, res) {
	patientModel.findOne({ mobile_no: req.mobile_no }, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			let ret = {
				patient: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
};

/**
 * @swagger
 * /patient/post/logout:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Patient
 *     summary: Logs out a patient
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
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       404:
 *         description: Data Not Found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.logout = async function (req, res) {
	patientModel.findOne({ mobile_no: req.mobile_no }, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
		} else {
			patientModel.updateOne({ mobile_no: req.mobile_no }, { $unset: { session_token: null } }, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).json(error_message.SUCCESS);
				}
			});
		}
	});
};
