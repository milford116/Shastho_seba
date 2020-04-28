const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.postAppointment = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doc_mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else if (!docs) {
			res.status(BAD_REQUEST).send("Bad request");
		} else {
			var appointment = new appointmentModel();
			appointment.doc_mobile_no = req.body.doc_mobile_no;
			appointment.doc_name = docs.name;
			appointment.patient_mobile_no = req.mobile_no;
			appointment.status = false;
			appointment.appointment_date_time = req.body.appointment_date_time;

			console.log(appointment);

			appointment.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
				} else {
					res.status(SUCCESS).send("Success");
				}
			});
		}
	});
};

exports.getAppointment = async function (req, res) {
	let st = new Date(Date.now());
	let en = new Date(Date.now());
	st.setHours(0, 0, 0, 0);
	en.setHours(23, 59, 59, 999);
	st.setHours(st.getHours() + 6);
	en.setHours(en.getHours() + 6);
	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: {$lte: en, $gte: st},
	};
	appointmentModel.find(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.getPastAppointment = async function (req, res) {
	let st = new Date(Date.now());
	st.setHours(st.getHours() + 6);
	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: {$lt: st},
	};
	appointmentModel.find(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.getFutureAppointment = async function (req, res) {
	let st = new Date(Date.now());
	st.setHours(23, 59, 59, 999);
	st.setHours(st.getHours() + 6);
	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: {$gt: st},
	};
	appointmentModel.find(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
