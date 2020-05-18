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

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.registration = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (docs) {
			res.status(BAD_REQUEST).send(error_message.duplicateAcc);
		} else {
			referenceModel.findOneAndDelete({doctor: req.body.mobile_no}, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else if (!docs) {
					res.status(BAD_REQUEST).send(error_message.noRef);
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
							res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
						} else {
							new_doctor.password = hash;
							new_doctor.save((err, docs) => {
								if (err) {
									res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
								} else {
									res.status(SUCCESS).send(error_message.SUCCESS);
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
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send(error_message.noUserFound);
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else if (!result) {
					res.status(BAD_REQUEST).send(error_message.passwordMismatch);
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
							res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
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
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).send(error_message.duplicateAcc);
		} else {
			var new_reference = new referenceModel();
			new_reference.referrer = req.mobile_no;
			new_reference.doctor = req.body.doctor;

			new_reference.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).send(error_message.SUCCESS);
				}
			});
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
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.editDoctor = async function (req, res) {
	let upd = {
		name: req.body.name,
		email: req.body.email,
		institution: req.body.institution,
		designation: req.body.designation,
	};

	console.log("from controller", req.mobile_no);

	doctorModel.updateOne({mobile_no: req.mobile_no}, upd, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else res.status(SUCCESS).send(error_message.SUCCESS);
	});
};

exports.uploadDP = async function (req, res) {
	doctorModel.updateOne({mobile_no: req.mobile_no}, {image: "/profilePicture/doctor/" + req.fileName}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).send(error_message.SUCCESS);
	});
};

exports.getProfile = async function (req, res) {
	doctorModel.findOne({mobile_no: req.mobile_no}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).send(docs);
	});
};
