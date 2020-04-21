const mongoose = require("mongoose");
const doctor = require("../models/doctor.model");
const reference = require("../models/reference.model");
const doctorModel = mongoose.model("doctor");
const referenceModel = mongoose.model("reference");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.registration = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (docs) {
			res.status(BAD_REQUEST).send("An account with this mobile no already exists");
		} else {
			referenceModel.findOneAndDelete({doctor: req.body.mobile_no}, (err, docs) => {
				if (err) {
					res.status(BAD_REQUEST).send("No referreral in this mobile no");
				} else {
					var new_doctor = new doctorModel();
					new_doctor.name = req.body.name;
					new_doctor.email = req.body.email;
					new_doctor.mobile_no = req.body.mobile_no;
					new_doctor.institution = req.body.institution;
					new_doctor.designation = req.body.designation;
					new_doctor.reg_number = req.body.reg_number;
					new_doctor.referrer = docs.referrer;

					const payload = {
						name: new_doctor.name,
						reg_number: new_doctor.reg_number,
					};

					new_doctor.session_token = jwt.sign(payload, process.env.SECRET);

					bcrypt.hash(
						req.body.password,
						parseInt(process.env.SALT_ROUNDS, 10),
						(err, hash) => {
							if (err) {
								res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
							} else {
								new_doctor.password = hash;
								new_doctor.save((err, docs) => {
									if (err) {
										res.status(INTERNAL_SERVER_ERROR).send(
											"something went wrong"
										);
									} else {
										res.status(SUCCESS).send(token);
									}
								});
							}
						}
					);
				}
			});
		}
	});
};

exports.login = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).send("no such user found");
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
				} else {
					const payload = {
						mobile_no: docs.mobile_no,
						name: docs.name,
						reg_number: docs.reg_number,
					};

					const token = jwt.sign(payload, process.env.SECRET);

					doctorModel.updateOne(
						{mobile_no: req.body.mobile_no},
						{session_token: token},
						(err, docs) => {
							if (err) {
								res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
							} else {
								res.status(SUCCESS).send(token);
							}
						}
					);
				}
			});
		}
	});
};

exports.reference = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doctor}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else if (docs) {
			res.status(BAD_REQUEST).send("This doctor already registered in our database");
		} else {
			var new_reference = new referenceModel();
			new_reference.referrer = req.body.referrer;
			new_reference.doctor = req.body.doctor;

			new_reference.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
				} else {
					res.status(SUCCESS).send("Successfully referred");
				}
			});
		}
	});
};
