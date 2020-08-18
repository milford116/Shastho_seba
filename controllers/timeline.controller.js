const mongoose = require("mongoose");
const timeline = require("../models/timeline.model");
const timelineModel = mongoose.model("timeline");
const doctor = require("../models/doctor.model");
const doctorModel = mongoose.model("doctor");
const patient = require("../models/patient.model");
const patientModel = mongoose.model("patient");
const appointment = require("../models/appointment.model");
const {SUCCESS} = require("../error.messages");
const appointmentModel = mongoose.model("appointment");

/**
 * @swagger
 * /doctor/get/timeline:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Timeline
 *     summary: timeline of a pair of doctor-patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               patient_mobile_no:
 *                 type: string
 *                 description: send this from the doctor app
 *               doctor_mobile_no:
 *                 type: string
 *                 description: send this from the patient app
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 timeline:
 *                   type: array
 *                   $ref: '#/components/schemas/timeline'
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

/**
 * @swagger
 * /patient/get/timeline:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Timeline
 *     summary: timeline of a pair of doctor-patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               patient_mobile_no:
 *                 type: string
 *                 description: send this from the doctor app
 *               doctor_mobile_no:
 *                 type: string
 *                 description: send this from the patient app
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 timeline:
 *                   type: array
 *                   $ref: '#/components/schemas/timeline'
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
exports.getTimeline = async function (req, res) {
	let doctorId = "";
	let patientId = "";

	if (req.body.patient_mobile_no) {
		doctorId = req._id;
		let patient = await patientModel.find({mobile_no: req.body.patient_mobile_no});
		patientId = patient._id;
	} else if (req.body.doctor_mobile_no) {
		patientId = req._id;
		let doctor = await doctorModel.find({mobile_no: req.body.doctor_mobile_no});
		doctorId = doctor._id;
	}

	let appointments = await appointmentModel.find({doctorId, patientId}, {_id}).exec();
	let ret = [];

	for (let i = 0; i < appointments.length; i++) {
		let log = await timelineModel.find({_id: appointments[i]._id});
		ret.push(log);
	}

	res.status(SUCCESS).json({timeline: ret});
};
