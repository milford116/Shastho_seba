const log = require("../models/log.model");
const logModel = mongoose.model("log");
const doctor = require("../models/doctor.model");
const doctorModel = mongoose.model("doctor");
const patient = require("../models/patient.model");
const patientModel = mongoose.model("patient");
const appointment = require("../models/appointment.model");
const {SUCCESS} = require("../error.messages");
const appointmentModel = mongoose.model("appointment");

exports.getLog = async function (req, res) {
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
		let log = await logModel.find({_id: appointments[i]._id});
		ret.push(log);
	}

	res.status(SUCCESS).json({logs: ret});
};
