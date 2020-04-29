const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");
const patient = require("../models/patient.model");

const patientModel = mongoose.model("patient");
const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.updateAppointment = async function (req, res) {
	appointmentModel.updateOne({_id: req.body.appointment_id}, {status: true}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else if (!docs) {
			res.status(BAD_REQUEST).send("Bad request");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.appointment = async function (req, res) {
	let st = new Date(Date.now());
	let en = new Date(Date.now());
	st.setHours(0, 0, 0, 0);
	en.setHours(23, 59, 59, 999);
	st.setHours(st.getHours() + 6);
	en.setHours(en.getHours() + 6);
	const query = {
		doc_mobile_no: req.mobile_no,
		appointment_date_time: {$lte: en, $gte: st},
	};

	let appointments = [];

	appointmentModel.find(query, async (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
		} else {
			for (let i = 0; i < docs.length; i++) {
				let obj = await patientModel.findOne({mobile_no: docs[i].patient_mobile_no}).exec();
				let data = {
					appointment_detail: docs[i],
					patient_detail: obj,
				};
				appointments.push(data);
			}
			res.status(SUCCESS).send(appointments);
		}
	});
};

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
			res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
		} else {
			for (let i = 0; i < docs.length; i++) {
				let obj = await patientModel.findOne({mobile_no: docs[i].patient_mobile_no}).exec();
				let data = {
					appointment_detail: docs[i],
					patient_detail: obj,
				};
				appointments.push(data);
			}
			res.status(SUCCESS).send(appointments);
		}
	});
};

exports.appointmentDetail = async function (req, res) {
	let data = {
		appointment_detail: {},
		patient: {},
	};

	appointmentModel.findOne({_id: req.body.appointment_id}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
		else {
			data.appointment_detail = docs;
			if (docs) {
				patientModel.find({mobile_no: docs.patient_mobile_no}, (err, obj) => {
					if (!err) {
						data.patient = obj;
						res.status(SUCCESS).send(data);
					} else res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
				});
			} else res.status(SUCCESS).send(data);
		}
	});
};
