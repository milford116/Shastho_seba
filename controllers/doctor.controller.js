const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const reference = require("../models/reference.model");
const appointment = require("../models/appointment.model");
const specialization = require("../models/specialization.model");
const patient = require("../models/patient.model");

const doctorModel = mongoose.model("doctor");
const referenceModel = mongoose.model("reference");
const appointmentModel = mongoose.model("appointment");
const patientModel = mongoose.model("patient");

const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.registration = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (docs) {
			res.status(BAD_REQUEST).send("An account with this mobile no. already exists");
		} else {
			referenceModel.findOneAndDelete({doctor: req.body.mobile_no}, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
				} else if (!docs) {
					res.status(BAD_REQUEST).send("Bad request");
				} else {
					var new_doctor = new doctorModel();
					new_doctor.name = req.body.name;
					new_doctor.email = req.body.email;
					new_doctor.mobile_no = req.body.mobile_no;
					new_doctor.institution = req.body.institution;
					new_doctor.designation = req.body.designation;
					new_doctor.reg_number = req.body.reg_number;
					new_doctor.referrer = docs.referrer;

					bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send("Something went wrong1");
						} else {
							new_doctor.password = hash;
							new_doctor.save((err, docs) => {
								if (err) {
									res.status(INTERNAL_SERVER_ERROR).send("Something went wrong2");
								} else {
									res.status(SUCCESS).send("Success");
								}
							});
						}
					});
				}
			});
		}
	});
};

exports.login = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send("No such user found");
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
				} else if (!result) {
					res.status(BAD_REQUEST).send("Bad request");
				} else {
					const payload = {
						mobile_no: docs.mobile_no,
						name: docs.name,
						reg_number: docs.reg_number,
					};

					const doctor_detail = docs;

					const token = jwt.sign(payload, process.env.SECRET);

					doctorModel.updateOne({mobile_no: req.body.mobile_no}, {session_token: token}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
						} else {
							const ret = {
								token: token,
								doctor_detail: doctor_detail,
							};

							res.status(SUCCESS).send(ret);
						}
					});
				}
			});
		}
	});
};

exports.reference = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doctor}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
		} else if (docs) {
			res.status(BAD_REQUEST).send("The doctor has already registered");
		} else {
			var new_reference = new referenceModel();
			new_reference.referrer = req.mobile_no;
			new_reference.doctor = req.body.doctor;

			new_reference.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
				} else {
					res.status(SUCCESS).send("Successfully referred");
				}
			});
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

exports.doctorList = async function (req, res) {
	var options = {
		page: parseInt(req.params.page, 10),
		limit: parseInt(req.params.limit, 10),
	};

	doctorModel.paginate({}, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
