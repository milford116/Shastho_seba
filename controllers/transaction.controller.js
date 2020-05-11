const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");
const transaction = require("../models/transaction.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");
const transactionModel = mongoose.model("transaction");

const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.addTransaction = async function (req, res) {
	var transaction = new transactionModel();
	transaction.appointment_id = req.body.appointment_id;
	transaction.transaction_id = req.body.transaction_id;
	transaction.amount = req.body.amount;

	transaction.save((err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(error_message.SUCCESS);
		}
	});
};

exports.getTransaction = async function (req, res) {
	transactionModel.find({appointment_id: req.body.appointment_id}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
