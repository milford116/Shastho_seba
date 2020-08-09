const mongoose = require("mongoose");
const appointment = require("../models/appointment.model");
const appointmentModel = mongoose.model("appointment");
const prescription = require("../models/prescription.model");
const prescriptionModel = mongoose.model("prescription");
const {SUCCESS, INTERNAL_SERVER_ERROR} = require("../errors");
const error_message = require("../error.messages");
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
 *               medicine:
 *                 type: array
 *                 description: array of suggested medicines
 *                 items:
 *                   type: string
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: prescription image
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

	if (req.filename) newPrescription.prescription_img = "/prescription/" + req.filename;
	if (req.body.medicine !== undefined) newPrescription.medicine = req.body.medicine;

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
