const mongoose = require('mongoose');

const doctor = require('../models/doctor.model');
const patient = require('../models/patient.model');
const appointment = require('../models/appointment.model');
const transaction = require('../models/transaction.model');

const doctorModel = mongoose.model('doctor');
const patientModel = mongoose.model('patient');
const appointmentModel = mongoose.model('appointment');
const transactionModel = mongoose.model('transaction');

const bcrypt = require('bcrypt');
const dotenv = require('dotenv');
const jwt = require('jsonwebtoken');
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require('../errors');

exports.registration = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
		} else if (docs) {
			res.status(BAD_REQUEST).send('An account with this mobile no already exists');
		} else {
			var new_patient = new patientModel();
			new_patient.mobile_no = req.body.mobile_no;
			new_patient.name = req.body.name;
			new_patient.date_of_birth = req.body.date_of_birth;
			new_patient.sex = req.body.sex;

			bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
				} else {
					new_patient.password = hash;

					new_patient.save((err, doc) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
						} else {
							res.status(SUCCESS).send('Successful registration');
						}
					});
				}
			});
		}
	});
};

exports.login = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send('No user found in this mobile no');
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
				} else if (!result) {
					res.status(BAD_REQUEST).send('Bad request');
				} else {
					const payload = {
						mobile_no: req.body.mobile_no,
						name: docs.name,
						age: docs.age,
					};

					const token = jwt.sign(payload, process.env.SECRET);

					patientModel.updateOne({mobile_no: req.body.mobile_no}, {session_token: token}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
						} else {
							res.status(SUCCESS).send(token);
						}
					});
				}
			});
		}
	});
};

exports.postAppointment = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doc_mobile_no}, (err, docs) => {
		var appointment = new appointmentModel();
		appointment.doc_mobile_no = req.body.doc_mobile_no;
		appointment.doc_name = docs.name;
		appointment.patient_mobile_no = req.mobile_no;
		appointment.status = false;
		appointment.appointment_date = req.body.appointment_date;

		console.log(appointment);

		appointment.save((err, docs) => {
			if (err) {
				res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
			} else {
				res.status(SUCCESS).send('Success');
			}
		});
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
		appointment_date: {$lte: en, $gte: st},
	};
	appointmentModel.find(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.addTransaction = async function (req, res) {
	var transaction = new transactionModel();
	transaction.appointment_id = req.body.appointment_id;
	transaction.amount = req.body.amount;

	transaction.save((err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send('Internal server error');
		} else {
			res.status(SUCCESS).send('Success');
		}
	});
};
