const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const admin = require("../models/admin.model");
const mongoose = require("mongoose");
const adminModel = mongoose.model("admin");
const {INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.middleware = async function (req, res, next) {
	if (req.headers.authorization) {
		const token = req.headers.authorization.split(" ")[1];
		jwt.verify(token, process.env.SECRET, (err, decode) => {
			if (err) {
				res.status(BAD_REQUEST).send(error_message.jwtErr);
			} else {
				adminModel.findOne({phone: decode.phone}, (err, docs) => {
					if (err) {
						res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
					} else if (!docs) {
						res.status(DATA_NOT_FOUND).send(error_message.noUserFound);
					} else {
						req.phone = docs.phone;
						req._id = docs._id;
						req.type = "admin";
						next();
					}
				});
			}
		});
	} else {
		res.status(BAD_REQUEST).send({message: "no request header sent"});
	}
};
