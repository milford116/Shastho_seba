const mongoose = require("mongoose");

const patient = require("../models/patient.model");

const patientModel = mongoose.model("patient");

const bcrypt = require("bcrypt");
const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.registration = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else if (docs) {
			res.status(BAD_REQUEST).send("An account with this mobile no already exists");
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
					res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
				} else {
					new_patient.password = hash;

					new_patient.save((err, doc) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
						} else {
							res.status(SUCCESS).send("Successful registration");
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
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send("No user found in this mobile no");
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
				} else if (!result) {
					res.status(BAD_REQUEST).send("Bad request");
				} else {
					var patient = new patientModel();
					patient = docs;
					const payload = {
						mobile_no: req.body.mobile_no,
						name: docs.name,
						age: docs.age,
					};

					const token = jwt.sign(payload, process.env.SECRET);

					patientModel.updateOne({mobile_no: req.body.mobile_no}, {session_token: token}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
						} else {
							patient.session_token = token;
							res.status(SUCCESS).send(patient);
						}
					});
				}
			});
		}
	});
};
