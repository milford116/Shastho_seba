const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const doctor = require("../models/doctor.model");
const mongoose = require("mongoose");
const doctorModel = mongoose.model("doctor");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.middleware = async function (req, res, next) {
	if (req.headers.authorization) {
		const token = req.headers.authorization.split(" ")[1];
		jwt.verify(token, process.env.SECRET, (err, decode) => {
			if (err) {
				res.status(BAD_REQUEST).send(error_message.jwtErr);
			} else {
				doctorModel.findOne({mobile_no: decode.mobile_no}, (err, docs) => {
					if (err) {
						res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
					} else if (!docs) {
						res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
					} else {
						req.mobile_no = docs.mobile_no;
						req._id = docs._id;
						req.type = "doctor";
						next();
					}
				});
			}
		});
	} else {
		res.status(BAD_REQUEST).send("Bad request");
	}
};
