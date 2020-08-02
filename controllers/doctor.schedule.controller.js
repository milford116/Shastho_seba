const mongoose = require("mongoose");
const schedule = require("../models/schedule.model");
const scheduleModel = mongoose.model("schedule");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

exports.addSchedule = async function (req, res) {
	var st = new Date(req.body.time_start);
	var en = new Date(req.body.time_end);
	st.setHours(st.getHours() + 6);
	en.setHours(en.getHours() + 6);
	st.setDate(1), st.setMonth(1), st.setFullYear(2000);
	en.setDate(1), en.setMonth(1), en.setFullYear(2000);
	var query = {
		doc_mobile_no: req.mobile_no,
		$or: [{time_start: {$lte: en, $gte: st}}, {time_end: {$lte: st, $gte: en}}],
		day: req.body.day,
	};

	scheduleModel.findOne(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			var new_schedule = new scheduleModel();
			new_schedule.doc_mobile_no = req.mobile_no;
			new_schedule.time_start = st;
			new_schedule.time_end = en;
			new_schedule.day = req.body.day;
			new_schedule.fee = req.body.fee;

			new_schedule.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).send(error_message.SUCCESS);
				}
			});
		}
	});
};

exports.getSchedule = async function (req, res) {
	scheduleModel.find({doc_mobile_no: req.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.editSchedule = async function (req, res) {
	var st = new Date(req.body.time_start);
	var en = new Date(req.body.time_end);
	st.setHours(st.getHours() + 6);
	en.setHours(en.getHours() + 6);
	st.setDate(1), st.setMonth(1), st.setFullYear(2000);
	en.setDate(1), en.setMonth(1), en.setFullYear(2000);

	var query = {
		doc_mobile_no: req.mobile_no,
		$or: [{time_start: {$lte: st, $gte: en}}, {time_end: {$lte: st, $gte: en}}],
		day: req.body.day,
	};

	let data = {
		doc_mobile_no: req.body.doc_mobile_no,
		time_start: req.body.time_start,
		time_end: req.body.time_end,
		day: req.body.day,
		fee: req.body.fee,
	};

	scheduleModel.findOne(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			scheduleModel.updateOne({_id: req.body.id}, data, (errU, docU) => {
				if (errU) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				else res.status(SUCCESS).send(error_message.SUCCESS);
			});
		}
	});
};