const mongoose = require("mongoose");
mongoose.set("useFindAndModify", false);

const appointment = require("../../models/appointment.model");
const patient = require("../../models/patient.model");
const doctor = require("../../models/doctor.model");

const patientModel = mongoose.model("patient");
const appointmentModel = mongoose.model("appointment");
const doctorModel = mongoose.model("doctor");

const {SUCCESS, INTERNAL_SERVER_ERROR, DATA_NOT_FOUND} = require("../../errors");
const error_message = require("../../error.messages");

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
			res.status(DATA_NOT_FOUND).json({messaage: "No such appointment found"});
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
 *   get:
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

	let doctor = await doctorModel.findOne({mobile_no: req.mobile_no});

	const query = {
		doctorId: doctor._id,
		appointment_date_time: {$gt: st},
	};

	let appointments = await appointmentModel.find(query).sort({appointment_date_time: -1}).populate("patientId", "mobile_no date_of_birth sex name image_link").exec();

	if (appointments) res.status(SUCCESS).send({appointments});
	else res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
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
	let appointment = await appointmentModel.findOne({_id: req.body.appointment_id}).populate("patientId", "mobile_no date_of_birth sex name image_link").exec();
	if (appointment) res.status(SUCCESS).send({appointment_detail: appointment});
	else res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
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
exports.appointmentInRange = async function (req, res) {
	var st = new Date();
	var en = new Date();

	st.setUTCHours(0, 0, 0, 0);
	en.setUTCHours(23, 59, 59, 999);

	var query = {
		schedule_id: req.params.id,
		appointment_date_time: {$gte: st, $lte: en},
	};

	let appointments = await appointmentModel.find(query).populate("patientId", "mobile_no date_of_birth sex name image_link").sort({createdAt: 1}).exec();
	res.status(SUCCESS).json({appointments});
};

/**
 * @swagger
 * /doctor/get/appointments:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Appointment
 *     summary: Gets the appointments of a doctor with a patient
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
	let doctor = await doctorModel.findOne({mobile_no: req.mobile_no});
	let patient = await patientModel.findOne({mobile_no: req.body.patient_mobile_no});

	var query = {
		patientId: patient._id,
		doctorId: doctor._id,
	};

	let appointments = await appointmentModel.find(query).sort({appointment_date_time: 1}).exec();

	if (appointments) res.status(SUCCESS).json({appointments});
	else res.status(DATA_NOT_FOUND).json({message: "No appointments found"});
};
