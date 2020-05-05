const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.postAppointment = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doc_mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			var date = new Date(req.body.appointment_date_time);
			date.setHours(date.getHours() + 6);

			var appointment = new appointmentModel();
			appointment.doc_mobile_no = req.body.doc_mobile_no;
			appointment.doc_name = docs.name;
			appointment.patient_mobile_no = req.mobile_no;
			appointment.status = false;
			appointment.appointment_date_time = date;

			appointment.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).send(error_message.SUCCESS);
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
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
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
	var options = {
		sort: {
			appointment_date_time: -1,
		},
	};
	appointmentModel.find(query, null, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
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
	var options = {
		sort: {
			appointment_date_time: 1,
		},
	};
	appointmentModel.find(query, null, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
