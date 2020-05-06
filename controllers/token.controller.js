const mongoose = require("mongoose");

const patient = require("../models/patient.model");
const patientModel = mongoose.model("patient");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.setToken = async function (req, res) {
	patientModel.updateOne({_id: req.body.id}, {registration_token: req.body.registration_token}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		else res.status(SUCCESS).send(error_message.SUCCESS);
	});
};

exports.getToken = async function (req, res) {
	patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		else res.status(SUCCESS).send(docs.registration_token);
	});
};
