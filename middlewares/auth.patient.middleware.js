const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const patient = require("../models/patient.model");
const mongoose = require("mongoose");
const patientModel = mongoose.model("patient");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND, UNAUTHORIZED} = require("../errors");
const error_message = require("../error.messages");

exports.middleware = async function (req, res, next) {
	if (req.headers.authorization) {
		const token = req.headers.authorization.split(" ")[1];
		jwt.verify(token, process.env.SECRET, (err, decode) => {
			if (err) {
				res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
			} else {
				patientModel.findOne({mobile_no: decode.mobile_no, name: decode.name}, (err, docs) => {
					if (err) {
						res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
					} else {
						req.mobile_no = docs.mobile_no;
						req.name = docs.name;
						req._id = docs._id;
						req.type = "patient";
						next();
					}
				});
			}
		});
	} else {
		res.status(UNAUTHORIZED).send(error_message.UNAUTHORIZED);
	}
};
