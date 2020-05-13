const mongoose = require("mongoose");

const appointment = require("../models/appointment.model");
const appointmentModel = mongoose.model("appointment");
const prescription = require("../models/prescription.model");
const prescriptionModel = mongoose.model("prescription");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");
const multer = require("multer");
const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/prescription/");
	},
	filename: function (req, file, cb) {
		cb(null, req.body.image_title + ".png");
	},
});

const upload = multer({storage: storage});

exports.postPrescription = async function (req, res) {
	var newPrescription = new prescriptionModel();
	newPrescription.appointment_id = req.body.id;

	if (req.body.image_title !== undefined) newPrescription.prescription_img = "/prescription/" + req.body.image_title + ".png";

	if (req.body.medicine !== undefined) newPrescription.medicine = req.body.medicine;

	newPrescription.save((err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).send(error_message.SUCCESS);
	});
};

exports.getPreviousPrescription = async function (req, res) {
	appointmentModel.find({patient_mobile_no: req.body.patient_mobile_no, status: 2}, async (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		else {
			let prescriptions = [];
			for (let i = 0; i < docs.length; i++) {
				let obj = await prescriptionModel.find({appointment_id: docs[i]._id}).exec();
				prescriptions.push(obj);
			}
			res.status(SUCCESS).send(prescriptions);
		}
	});
};
