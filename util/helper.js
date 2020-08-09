const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const patient = require("../models/patient.model");
const patientModel = mongoose.model("patient");
const doctor = require("../models/doctor.model");
const doctorModel = mongoose.model("doctor");

exports.jwtVerifier = async function (token, cb) {
	let tokenString = token.split(" ")[1];

	jwt.verify(tokenString, process.env.SECRET, async (err, decode) => {
		if (!err) {
			let patient = await patientModel.findOne({mobile_no: decode.mobile_no});
			if (patient) {
				let user = {
					type: "patient",
					detail: patient,
				};
				cb(null, patient);
			}

			let doctor = await doctorModel.findOne({mobile_no: decode.mobile_no});
			if (doctor) {
				let user = {
					type: "doctor",
					detail: doctor,
				};
				cb(null, user);
			}
		} else {
			cb("jwt verification error", {});
		}
	});
};
