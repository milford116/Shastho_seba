const mongoose = require("mongoose");

const schedule = require("../models/schedule.model");

const scheduleModel = mongoose.model("schedule");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.getSchedule = async function (req, res) {
	scheduleModel.find({doc_mobile_no: req.body.mobile_no}, null, {sort: {day: 1, time_start: 1}}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
