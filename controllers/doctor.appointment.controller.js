const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.updateAppointment = async function (req, res) {
	appointmentModel.updateOne({appointment_id: req.body.appointment_id}, {status: true}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send("Sucees");
		}
	});
};
