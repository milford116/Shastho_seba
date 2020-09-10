const mongoose = require("mongoose");
mongoose.set("useFindAndModify", false);
const doctor = require("../../models/doctor.model");
const doctorModel = mongoose.model("doctor");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../../errors");
const error_message = require("../../error.messages");

exports.getAllDoctor = async function (req, res) {
	const page = req.body.page;
	const limit = req.body.limit;

	const total = await doctorModel.countDocuments();
	const doctors = await doctorModel
		.find()
		.skip(page * limit)
		.limit(limit)
		.select("name designation institution reg_number mobile_no email image specialization about_me")
		.exec();

	if (doctor) {
		let ret = {total, doctors};
		res.status(SUCCESS).json(ret);
	} else res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
};
