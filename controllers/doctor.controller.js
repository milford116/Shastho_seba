const mongoose = require('mongoose');
const doctor = require('../models/doctor.model');
const doctorModel = mongoose.model('doctor');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST } = require('../errors');

exports.registration = async function (req, res) {
	doctorModel.findOne({ email: req.body.email }, (err, docs) => {
		if (docs)
			res.send(BAD_REQUEST, 'An account with this email already exists');
		else {
			var new_doctor = new doctorModel();
			new_doctor.name = req.body.name;
			new_doctor.email = req.body.email;
			new_doctor.mobile_no = req.body.mobile_no;
			new_doctor.institution = req.body.institution;
			new_doctor.designation = req.body.designation;
			new_doctor.reg_number = req.body.reg_number;

			const payload = {
				name: new_doctor.name,
				reg_number: new_doctor.reg_number,
			};

			new_doctor.session_token = jwt.sign(payload, process.env.SECRET);

			bcrypt.hash(
				req.body.password,
				parseInt(process.env.SALT_ROUNDS, 10),
				(err, hash) => {
					if (err) res.send(err);
					else {
						new_doctor.password = hash;
						new_doctor.save((err, docs) => {
							if (err) res.send(INTERNAL_SERVER_ERROR, 'something went wrong');
							else res.send(SUCCESS, 'Successfully registered');
						});
					}
				}
			);
		}
	});
};
