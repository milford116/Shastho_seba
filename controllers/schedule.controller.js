const mongoose = require("mongoose");

const schedule = require("../models/schedule.model");

const scheduleModel = mongoose.model("schedule");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.addSchedule = async function (req, res) {
	var st = new Date(req.body.time_start);
	var en = new Date(req.body.time_end);
	st.setHours(st.getHours() + 6);
	en.setHours(en.getHours() + 6);
	st.setDate(1), st.setMonth(1), st.setFullYear(2000);
	en.setDate(1), en.setMonth(1), en.setFullYear(2000);
	var query = {
		doc_mobile_no: req.mobile_no,
		time_start: {$gte: st},
		time_end: {$lte: en},
		day: req.body.day,
	};

	scheduleModel.findOne(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else if (docs) {
			res.status(BAD_REQUEST).send("Bad request");
		} else {
			var new_schedule = new scheduleModel();
			new_schedule.doc_mobile_no = req.mobile_no;
			new_schedule.time_start = st;
			new_schedule.time_end = en;
			new_schedule.day = req.body.day;
			new_schedule.fee = req.body.fee;

			new_schedule.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
				} else {
					res.status(SUCCESS).send("Success");
				}
			});
		}
	});
};

exports.getSchedule = async function (req, res) {
	scheduleModel.find({doc_mobile_no: req.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
