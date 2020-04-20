const express = require('express');
const router = express.router();
const mongoose = require('mongoose');
const doctorModel = mongoose.model('../models/doctor.model.js');
const md5 = require('md5');
const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST } = require('../errors');

async function registration(req, res) {
	doctorModel.findOne({ email: req.body.email }, (err, docs) => {
		if (docs)
			res.send(BAD_REQUEST, 'An account with this email already exists');
		else {
			var new_doctor = new userModel();
			new_doctor.name = req.body.name;
			new_doctor.email = req.body.email;
			new_doctor.phone = req.body.phone;
			new_doctor.password = md5(req.body.password);
			new_doctor.institution = req.body.institution;
			new_doctor.designation = req.body.designation;
			new_doctor.reg_number = req.body.reg_number;

			const payload = {
				name: new_doctor.name,
				reg_number: new_doctor.reg_number,
			};

			new_doctor.session_token = jwt.sign(payload, process.env.SECRET);

			new_doctor.save((err, docs) => {
				if (err) res.send(INTERNAL_SERVER_ERROR, 'something went wrong');
				else res.send(SUCCESS, 'Successfully registered');
			});
		}
	});
}
