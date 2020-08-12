const mongoose = require("mongoose");
mongoose.set("useFindAndModify", false);

const appointment = require("../models/appointment.model");
const patient = require("../models/patient.model");

const patientModel = mongoose.model("patient");
const appointmentModel = mongoose.model("appointment");

const {SUCCESS, INTERNAL_SERVER_ERROR, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

/**
 * @swagger
 * /doctor/update/appointment:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: updates the status of an appointment
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               appointment_id:
 *                 type: string
 *               status:
 *                 type: number
 *                 description: 1 or 2
 *             required:
 *               - appointment_id
 *               - status
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 appointment_detail:
 *                   $ref: '#/components/schemas/appointment'
 *       500:
 *         description: Internal Server Error
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
exports.updateAppointment = async function (req, res) {
	appointmentModel.findOneAndUpdate({_id: req.body.appointment_id}, {status: req.body.status}, {new: true}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json("no appointment found");
		} else {
			let ret = {
				appointment_detail: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
};

/**
 * @swagger
 * /doctor/get/futureAppointment:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: get the future appointments
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
 *                     type: object
 *                     properties:
 *                       appointment_detail:
 *                         $ref: '#/components/schemas/appointment'
 *                       patient_detail:
 *                         $ref: '#/components/schemas/patient'
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
exports.getFutureAppointment = async function (req, res) {
	let st = new Date(Date.now());
	st.setHours(23, 59, 59, 999);
	st.setHours(st.getHours() + 6);

	const query = {
		doc_mobile_no: req.mobile_no,
		appointment_date_time: {$gt: st},
	};

	let appointments = [];

	appointmentModel.find(query, async (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			for (let i = 0; i < docs.length; i++) {
				let obj = await patientModel.findOne({mobile_no: docs[i].patient_mobile_no}).exec();
				let data = {
					appointment_detail: docs[i],
					patient_detail: obj,
				};
				appointments.push(data);
			}

			let ret = {
				appointments,
			};
			res.status(SUCCESS).json(ret);
		}
	});
};

/**
 * @swagger
 * /doctor/get/appointmentDetail:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: get the details of an appointment
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
 *                 appointment_detail:
 *                   $ref: '#/components/schemas/appointment'
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
exports.appointmentDetail = async function (req, res) {
	let data = {
		appointment_detail: {},
		patient: {},
	};

	appointmentModel.findOne({_id: req.body.appointment_id}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else if (!docs) res.status(DATA_NOT_FOUND).json({message: "appointment not found"});
		else {
			data.appointment_detail = docs;
			if (docs) {
				patientModel.find({mobile_no: docs.patient_mobile_no}, (err, obj) => {
					if (!err) {
						data.patient = obj;
						res.status(SUCCESS).json(data);
					} else res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				});
			} else res.status(SUCCESS).json(data);
		}
	});
};

/**
 * @swagger
 * /doctor/get/appointment/{id}:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: appointments under that schedule
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: Numeric ID of the schedule
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
exports.appointmentInRange = async function (req, res) {
	var st = new Date();
	var en = new Date();

	st.setUTCHours(0, 0, 0, 0);
	en.setUTCHours(23, 59, 59, 999);

	var query = {
		schedule_id: req.params.id,
		appointment_date_time: {$gte: st, $lte: en},
	};

	let appointments = await appointmentModel.find(query).exec();
	res.status(SUCCESS).json({appointments});
};
