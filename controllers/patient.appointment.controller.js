const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");
const schedule = require("../models/schedule.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");
const scheduleModel = mongoose.model("schedule");

const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND } = require("../errors");
const error_message = require("../error.messages");

function setDateTime(cur, date) {
	cur.setUTCFullYear(date.getUTCFullYear());
	cur.setUTCMonth(date.getUTCMonth());
	cur.setUTCDate(date.getUTCDate());
	return cur;
}

/*
2 tarik ---- 2345 ---- 2
13 tarik ----
15 tarik ---- 2345 ---- 0/1
22 tarik ----- 2345 ---- 0/1

schedule --- 2000-01-01 5:00 - 2000-01-01 7:00 saturday 
date time ---- 2020-08-13 00:00
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
				patient_mobile_no: req.mobile_no,
				status: { $lt: 2 },
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

					var max_collection = await appointmentModel.find(query2).sort({ serial_no: -1 }).limit(1).exec();

					var appointment = new appointmentModel();
					appointment.schedule_id = req.body.schedule_id;
					appointment.doc_mobile_no = req.body.doc_mobile_no;
					appointment.doc_name = docs.name;
					appointment.patient_mobile_no = req.mobile_no;
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

	var query = {
		patient_mobile_no: req.mobile_no,
		status: { $lt: 2 },
		appointment_date_time: date,
	};

	appointmentModel.find(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				appointments: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
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

	var query = {
		patient_mobile_no: req.mobile_no,
		status: 2,
		appointment_date_time: { $lte: date },
	};

	var options = {
		sort: {
			appointment_date_time: -1,
		},
	};

	appointmentModel.find(query, null, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				appointments: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
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

	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: { $gt: date },
	};

	var options = {
		sort: {
			appointment_date_time: 1,
		},
	};

	appointmentModel.find(query, null, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				appointments: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
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
	appointmentModel.deleteOne({ _id: req.body.id }, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs.deletedCount === 0) {
			res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
		} else {
			res.status(SUCCESS).json(error_message.SUCCESS);
		}
	});
};