const mongoose = require("mongoose");

const doctor = require("../../models/doctor.model");
const appointment = require("../../models/appointment.model");
const schedule = require("../../models/schedule.model");
const patient = require("../../models/patient.model");
const timeline = require("../../models/timeline.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");
const scheduleModel = mongoose.model("schedule");
const patientModel = mongoose.model("patient");
const timelineModel = mongoose.model("timeline");

const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND } = require("../../errors");
const error_message = require("../../error.messages");

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
 *                   type: number
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
exports.postAppointment = async function (req, res) {
	doctorModel.findOne({ mobile_no: req.body.doc_mobile_no }, async (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			var date = new Date(req.body.appointment_date_time);
			date.setUTCHours(0, 0, 0, 0);

			var query1 = {
				schedule_id: req.body.schedule_id,
				patientId: req._id,
				status: { $lt: 3 },
				appointment_date_time: date,
			};

			appointmentModel.findOne(query1, async (err, doc) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else if (doc) {
					res.status(BAD_REQUEST).json({ message: "Appointment already exists" });
				} else {
					var query2 = {
						schedule_id: req.body.schedule_id,
						appointment_date_time: date,
					};

					var schedule_details = await scheduleModel.findOne({ _id: req.body.schedule_id }).exec();
					var max_collection = await appointmentModel.find(query2).sort({ serial_no: -1 }).limit(1).exec();
					var patient_detail = await patientModel.findOne({ mobile_no: req.mobile_no }).exec();

					var appointment = new appointmentModel();
					appointment.schedule_id = req.body.schedule_id;
					appointment.doctorId = docs._id;
					appointment.patientId = patient_detail._id;
					appointment.status = 1;
					appointment.appointment_date_time = date;
					appointment.due = schedule_details.fee;

					if (max_collection == schedule_details.limit) {
						res.status(BAD_REQUEST).json({ message: "Sorry! This slot has already been filled. Try another slot." });
					} else {
						if (max_collection.length != 0) {
							appointment.serial_no = parseInt(max_collection[0].serial_no) + parseInt(1);
						} else {
							appointment.serial_no = 1;
						}

						appointment.save(async (err, docs) => {
							if (err) {
								res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
							} else {
								var ret = {
									serial_no: appointment.serial_no,
								};

								let timeline_data = new timelineModel();
								timeline_data.doctor_mobile_no = req.body.doc_mobile_no;
								timeline_data.patient_mobile_no = req.mobile_no;
								timeline_data.appointment_id = docs._id;
								timeline_data.appointment_date = date;
								timeline_data.appointment_createdAt = Date.now();
								timeline_data.due = schedule_details.fee;

								await timeline_data.save();
								res.status(SUCCESS).json(ret);
							}
						});
					}
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

	let patient = await patientModel.findOne({ mobile_no: req.mobile_no }, { _id: 1 });

	var query = {
		patientId: patient._id,
		status: { $lt: 3 },
		appointment_date_time: date,
	};

	let appointments = await appointmentModel.find(query)
		.populate("schedule_id", "time_start")
		.populate("doctorId", "name designation institution reg_number mobile_no email image specialization about_me")
		.exec();

	if (appointments) {
		res.status(SUCCESS).json({ appointments });
	} else {
		res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
	}
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

	let patient = await patientModel.findOne({ mobile_no: req.mobile_no }, { _id: 1 });

	var query = {
		patientId: patient._id,
		status: { $lt: 3 },
		appointment_date_time: { $lte: date },
	};

	let appointments = await appointmentModel
		.find(query)
		.sort({ appointment_date_time: -1 })
		.populate("doctorId", "name designation institution reg_number mobile_no email image specialization about_me")
		.exec();

	if (appointments) res.status(SUCCESS).json({ appointments });
	else res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
};

/**
 * @swagger
 * /patient/get/appointments:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Gets the appointments of a patient
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
exports.getAppointments = async function (req, res) {

	let patient = await patientModel.findOne({ mobile_no: req.mobile_no });

	let doctor = await doctorModel.findOne({ mobile_no: req.body.doctor_mobile_no });

	var query = {
		patientId: patient._id,
		doctorId: doctor._id,
	};

	let appointments = await appointmentModel
		.find(query)
		.sort({ appointment_date_time: 1 })
		.exec();

	if (appointments) res.status(SUCCESS).json({ appointments });
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

	let patient = await patientModel.findOne({ mobile_no: req.mobile_no });

	var query = {
		patientId: patient._id,
		appointment_date_time: { $gt: date },
	};

	let appointments = await appointmentModel
		.find(query)
		.sort({ appointment_date_time: 1 })
		.populate("schedule_id", "time_start time_end")
		.populate("doctorId", "name designation institution reg_number mobile_no email image specialization about_me")
		.exec();

	if (appointments) res.status(SUCCESS).json({ appointments });
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
	appointmentModel.deleteOne({ _id: req.body.id }, async (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs.deletedCount === 0) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			await timelineModel.findOneAndDelete({ appointment_id: req.body.id }).exec();
			res.status(SUCCESS).json(error_message.SUCCESS);
		}
	});
};
