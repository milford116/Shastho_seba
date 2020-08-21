const mongoose = require("mongoose");
const appointment = require("../../models/appointment.model");
const appointmentModel = mongoose.model("appointment");
const prescription = require("../../models/prescription.model");
const prescriptionModel = mongoose.model("prescription");
const timeline = require("../../models/timeline.model");
const timelineModel = mongoose.model("timeline");

const {SUCCESS, INTERNAL_SERVER_ERROR} = require("../../errors");
const error_message = require("../../error.messages");
const path = require("path");
const multer = require("multer");

const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/prescription/");
	},
	filename: function (req, file, cb) {
		if (file) {
			let filename = "Prescription-" + req.mobile_no + "_" + req.body.appointment_id + path.extname(file.originalname);
			req.filename = filename;
			cb(null, filename);
		} else cb("no file found", null);
	},
});

const upload = multer({storage});
exports.upload = upload;

/**
 * @swagger
 * /doctor/save/prescription:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Prescription
 *     summary: prescription of an user
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               appointment_id:
 *                 type: string
 *               patient_name:
 *                 type: string
 *               patient_age:
 *                 type: number
 *               patient_sex:
 *                 type: string
 *               symptoms:
 *                 type: array
 *                 items:
 *                   type: string
 *               tests:
 *                 type: array
 *                 items:
 *                   type: string
 *               medicine:
 *                 type: array
 *                 description: array of suggested medicines
 *                 items:
 *                   type: object
 *                   additionalProperties: true
 *                   properties:
 *                     name:
 *                       type: string
 *                     dose:
 *                       type: string
 *                     day:
 *                       type: string
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: prescription image
 *             required:
 *               - appointment_id
 *               - patient_name
 *               - patient_age
 *               - patient_sex
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
 */
exports.postPrescription = async function (req, res) {
	var newPrescription = new prescriptionModel();
	newPrescription.appointment_id = req.body.appointment_id;
	newPrescription.patient_name = req.body.patient_name;
	newPrescription.patient_age = req.body.patient_age;
	newPrescription.patient_sex = req.body.patient_sex;
	newPrescription.symptoms = req.body.symptoms;

	if (req.body.tests) newPrescription.tests = req.body.tests;
	if (req.body.medicine) newPrescription.medicine = req.body.medicine;

	const url = req.protocol + "://" + req.get("host");
	if (req.filename) newPrescription.prescription_img = url + "/prescription/" + req.filename;
	if (req.body.medicine !== undefined) newPrescription.medicine = req.body.medicine;

	await timelineModel.updateOne({appointment_id: req.body.appointment_id}, {prescription_createdAt: Date.now()}).exec();

	newPrescription.save((err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).json(error_message.SUCCESS);
	});
};

/**
 * @swagger
 * /doctor/get/prevPrescription:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Prescription
 *     summary: previous prescriptions of an user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               patient_mobile_no:
 *                 type: string
 *             required:
 *               - patient_mobile_no
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 prescriptions:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/prescription'
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
exports.getPreviousPrescription = async function (req, res) {
	appointmentModel.find({patient_mobile_no: req.body.patient_mobile_no, status: 2}, async (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else {
			let prescriptions = [];
			for (let i = 0; i < docs.length; i++) {
				let obj = await prescriptionModel.find({appointment_id: docs[i]._id}).exec();
				prescriptions.push(obj);
			}

			let ret = {
				prescriptions,
			};

			res.status(SUCCESS).json(ret);
		}
	});
};
