const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const reference = require("../models/reference.model");
const appointment = require("../models/appointment.model");
const specialization = require("../models/specialization.model");
const patient = require("../models/patient.model");

const doctorModel = mongoose.model("doctor");
const referenceModel = mongoose.model("reference");
const appointmentModel = mongoose.model("appointment");
const patientModel = mongoose.model("patient");
mongoose.set("useFindAndModify", false);

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

/**
 * @swagger
 * /doctor/post/register/:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Doctor
 *     summary: registration of a doctor
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/doctor'
 *     responses:
 *       200:
 *         description: Success
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.registration = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (docs) {
			res.status(BAD_REQUEST).send(error_message.duplicateAcc);
		} else {
			referenceModel.findOneAndDelete({doctor: req.body.mobile_no}, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else if (!docs) {
					res.status(BAD_REQUEST).send(error_message.noRef);
				} else {
					var new_doctor = new doctorModel();
					new_doctor.name = req.body.name;
					new_doctor.email = req.body.email;
					new_doctor.mobile_no = req.body.mobile_no;
					new_doctor.institution = req.body.institution;
					new_doctor.designation = req.body.designation;
					new_doctor.reg_number = req.body.reg_number;
					new_doctor.referrer = docs.referrer;

					bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
						} else {
							new_doctor.password = hash;
							new_doctor.save((err, docs) => {
								if (err) {
									res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
								} else {
									res.status(SUCCESS).send(error_message.SUCCESS);
								}
							});
						}
					});
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/post/login:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Doctor
 *     summary: logs in a doctor
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
 *                 doctor_detail:
 *                   ref: '#/components/schemas/doctor'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       404:
 *         description: Data Not Found
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.login = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send(error_message.noUserFound);
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else if (!result) {
					res.status(BAD_REQUEST).send(error_message.passwordMismatch);
				} else {
					const payload = {
						mobile_no: docs.mobile_no,
					};

					const doctor_detail = docs;

					const token = jwt.sign(payload, process.env.SECRET);

					doctorModel.updateOne({mobile_no: req.body.mobile_no}, {session_token: token}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
						} else {
							const ret = {
								token: token,
								doctor_detail: doctor_detail,
							};

							res.status(SUCCESS).send(ret);
						}
					});
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/post/reference:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: refer a doctor
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               doctor:
 *                 type: string
 *                 description: doctors mobile no whom we want to reffer
 *             required:
 *               - doctor
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.reference = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doctor}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).send(error_message.duplicateAcc);
		} else {
			var new_reference = new referenceModel();
			new_reference.referrer = req.mobile_no;
			new_reference.doctor = req.body.doctor;

			new_reference.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).send(error_message.SUCCESS);
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/list/all/:limit/:page:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: list of doctors, limit numbers per page.
 *     parameters:
 *       - in: path
 *         name: limit
 *         schema:
 *           type: integer
 *         required: true
 *         description: Numeric ID of the limit
 *       - in: path
 *         name: page
 *         schema:
 *           type: integer
 *         required: true
 *         description: Numeric ID of the page
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/doctor'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.doctorList = async function (req, res) {
	var options = {
		page: parseInt(req.params.page, 10),
		limit: parseInt(req.params.limit, 10),
	};

	doctorModel.paginate({}, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

/**
 * @swagger
 * /doctor/edit/profile:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: edit the detail of a doctor. just add the fields that are being updated
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               newDoctor:
 *                 type: object
 *                 $ref: '#/components/schemas/doctor'
 *             required:
 *               - newDoctor
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               ref: '#/components/schemas/doctor'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.editDoctor = async function (req, res) {
	let updates = req.body.newDoctor;
	doctorModel.findOneAndUpdate({mobile_no: req.mobile_no}, updates, {new: true}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else res.status(SUCCESS).send(docs);
	});
};

/**
 * @swagger
 * /doctor/upload/profile_picture:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: Posts the profile picture of the doctor
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.uploadDP = async function (req, res) {
	doctorModel.updateOne({mobile_no: req.mobile_no}, {image: "/profilePicture/doctor/" + req.fileName}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).send(error_message.SUCCESS);
	});
};

/**
 * @swagger
 * /doctor/get/profile:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: get the profile of a doctor
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               ref: '#/components/schemas/doctor'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 */
exports.getProfile = async function (req, res) {
	doctorModel.findOne({mobile_no: req.mobile_no}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).send(docs);
	});
};
