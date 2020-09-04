const mongoose = require("mongoose");
mongoose.set("useFindAndModify", false);
const admin = require("../../models/admin.model");
const adminModel = mongoose.model("admin");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../../errors");
const error_message = require("../../error.messages");

exports.create = async function (req, res) {
	let old_admin = await adminModel.find({phone: req.body.phone}).exec();

	if (!old_admin) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
	else if (old_admin && old_admin.length) res.status(BAD_REQUEST).json({message: "admin already exists"});
	else {
		let new_admin = new adminModel();
		new_admin.phone = req.body.phone;
		new_admin.name = req.body.name;
		new_admin.password = req.body.password;

		new_admin.save((err) => {
			if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
			else res.status(SUCCESS).json(error_message.SUCCESS);
		});
	}
};

exports.login = async function (req, res) {
	adminModel.findOne({phone: req.body.phone}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.jwtErr);
				} else if (!result) {
					res.status(BAD_REQUEST).json(error_message.BAD_REQUEST);
				} else {
					const payload = {
						phone: req.body.phone,
						name: docs.name,
					};

					const token_value = jwt.sign(payload, process.env.SECRET);
					const ret = {
						token: token_value,
					};

					adminModel.findOneAndUpdate({phone: req.body.phone}, {session_token: token_value}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							ret.user = docs;
							res.status(SUCCESS).json(ret);
						}
					});
				}
			});
		}
	});
};

exports.changePassword = async function (req, res) {
	adminModel.findOne({phone: req.phone}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
		} else {
			bcrypt.compare(req.body.old_password, docs.password, async (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.jwtErr);
				} else if (!result) {
					res.status(BAD_REQUEST).json({message: "old password doesn't match"});
				} else {
					const salt = await bcrypt.genSalt(parseInt(process.env.SALT_ROUNDS, 10));
					const passwordHash = await bcrypt.hash(req.body.new_password, salt);

					adminModel.findOneAndUpdate({phone: req.body.phone}, {session_token: null, password: passwordHash}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							ret.user = docs;
							res.status(SUCCESS).json(ret);
						}
					});
				}
			});
		}
	});
};
