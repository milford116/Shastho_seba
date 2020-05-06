const mongoose = require("mongoose");

const patient = require("../models/patient.model");

const patientModel = mongoose.model("patient");

const bcrypt = require("bcrypt");
const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.registration = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			var dob = new Date(req.body.date_of_birth);
			dob.setHours(dob.getHours() + 6);
			var new_patient = new patientModel();
			new_patient.mobile_no = req.body.mobile_no;
			new_patient.name = req.body.name;
			new_patient.date_of_birth = dob;
			new_patient.sex = req.body.sex;

			bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else {
					new_patient.password = hash;

					new_patient.save((err, doc) => {
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
};

exports.login = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send(error_message.DATA_NOT_FOUND);
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else if (!result) {
					res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
				} else {
					const payload = {
						mobile_no: req.body.mobile_no,
						name: docs.name,
						age: docs.age,
					};

					const token_value = jwt.sign(payload, process.env.SECRET);
					const token = {
						token: token_value,
					};

					patientModel.updateOne({mobile_no: req.body.mobile_no}, {session_token: token_value}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
						} else {
							res.status(SUCCESS).send(token);
						}
					});
				}
			});
		}
	});
};

exports.details = async function (req, res) {
	patientModel.findOne({mobile_no: req.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.logout = async function (req, res) {
	patientModel.findOne({mobile_no: req.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send(error_message.DATA_NOT_FOUND);
		} else {
			patientModel.updateOne({mobile_no: req.mobile_no}, {$unset: {session_token: null}}, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).send(error_message.SUCCESS);
				}
			});
		}
	});
};
