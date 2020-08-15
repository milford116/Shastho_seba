const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");
const schedule = require("../models/schedule.model");
const patient = require("../models/patient.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");
const scheduleModel = mongoose.model("schedule");
const patientModel = mongoose.model("patient");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

/**
 * @swagger
 * /patient/post/appointment:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Get an appointment
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               schedule_id:
 *                 type: string
 *               doc_mobile_no:
 *                 type: string
 *               appointment_date_time:
 *                 type: string
 *                 format: date-time
 *             required:
 *               - schedule_id
 *               - doc_mobile_no
 *               - appointment_date_time
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 serial_no:
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
exports.postAppointment = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doc_mobile_no}, async (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			var date = new Date(req.body.appointment_date_time);
			date.setUTCHours(0, 0, 0, 0);

			var query1 = {
				schedule_id: req.body.schedule_id,
				patient_mobile_no: req.mobile_no,
				status: {$lt: 2},
				appointment_date_time: date,
			};

			appointmentModel.findOne(query1, async (err, doc) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else if (doc) {
					res.status(BAD_REQUEST).json("Appointment has already been existed");
				} else {
					var query2 = {
						schedule_id: req.body.schedule_id,
						appointment_date_time: date,
					};

					var max_collection = await appointmentModel.find(query2).sort({serial_no: -1}).limit(1).exec();
					var patient_detail = await patientModel.findOne({mobile_no: req.mobile_no}).exec();

					var appointment = new appointmentModel();
					appointment.schedule_id = req.body.schedule_id;
					appointment.doctorId = docs._id;
					appointment.patientId = patient_detail._id;
					appointment.status = 0;
					appointment.appointment_date_time = date;

					if (max_collection.length != 0) {
						appointment.serial_no = parseInt(max_collection[0].serial_no) + parseInt(1);
					} else {
						appointment.serial_no = 1;
					}

					appointment.save((err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							var ret = {
								serial_no: appointment.serial_no,
							};
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
 * /patient/get/today/appointment:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Appointments of today for a patient
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 appointments:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/appointment'
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
exports.getAppointment = async function (req, res) {
	let date = new Date(Date.now());
	date.setUTCHours(0, 0, 0, 0);

	let patient = await patientModel.findOne({mobile_no: req.mobile_no}, {_id: 1});

	var query = {
		patientId: patient._id,
		status: {$lt: 2},
		appointment_date_time: date,
	};

	let appointments = await appointmentModel
		.find(query)
		.populate("doctorId", "name designation institute reg_number mobile_no email image specialization about_me")
		.populate("patientId", "mobile_no date_of_birth sex name image_link")
		.exec();

	if (appointments) res.status(SUCCESS).json({appointments});
	else res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
};

/**
 * @swagger
 * /patient/get/past/appointment:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Gets the past appointments of the patient
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 appointments:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/appointment'
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
exports.getPastAppointment = async function (req, res) {
	let date = new Date(Date.now());
	date.setUTCHours(0, 0, 0, 0);

	let patient = await patientModel.findOne({mobile_no: req.mobile_no}, {_id: 1});

	var query = {
		patientId: patient._id,
		status: {$lt: 2},
		appointment_date_time: {$lte: date},
	};

	let appointments = await appointmentModel
		.find(query)
		.sort({appointment_date_time: -1})
		.populate("doctorId", "name designation institute reg_number mobile_no email image specialization about_me")
		.populate("patientId", "mobile_no date_of_birth sex name image_link")
		.exec();

	if (appointments) res.status(SUCCESS).json({appointments});
	else res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
};

/**
 * @swagger
 * /patient/get/future/appointment:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Gets the upcoming appointments of the patient
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 appointments:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/appointment'
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
exports.getFutureAppointment = async function (req, res) {
	let date = new Date(Date.now());
	date.setUTCHours(0, 0, 0, 0);

	let patient = await patientModel.findOne({mobile_no: req.mobile_no}, {_id: 1});

	var query = {
		patientId: patient._id,
		appointment_date_time: {$gt: date},
	};

	let appointments = await appointmentModel
		.find(query)
		.sort({appointment_date_time: 1})
		.populate("doctorId", "name designation institute reg_number mobile_no email image specialization about_me")
		.populate("patientId", "mobile_no date_of_birth sex name image_link")
		.exec();

	if (appointments) res.status(SUCCESS).json({appointments});
	else res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
};

/**
 * @swagger
 * /patient/cancel/appointment:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Lets the patient cancel an appointment
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id:
 *                 type: string
 *             required:
 *               - id
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
exports.cancelAppointment = async function (req, res) {
	appointmentModel.deleteOne({_id: req.body.id}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs.deletedCount === 0) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			res.status(SUCCESS).json(error_message.SUCCESS);
		}
	});
};
