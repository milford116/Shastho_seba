const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const patient = require("../models/patient.model");
const patientModel = mongoose.model("patient");
const doctor = require("../models/doctor.model");
const doctorModel = mongoose.model("doctor");

exports.jwtVerifier = async function (data, cb) {
	let tokenString = data.token.split(" ")[1];

	jwt.verify(tokenString, process.env.SECRET, async (err, decode) => {
		if (!err) {
			let user = {
				type: data.type,
			};

			if (data.type === "doctor") {
				let doctor = await doctorModel.findOne({mobile_no: decode.mobile_no});
				user.detail = doctor;
			} else {
				let patient = await patientModel.findOne({mobile_no: decode.mobile_no});
				user.detail = patient;
			}

			cb(null, user);
		} else {
			cb("jwt verification error", {});
		}
	});
};
