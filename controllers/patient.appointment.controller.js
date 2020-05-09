const mongoose = require("mongoose");

const doctor = require("../models/doctor.model");
const appointment = require("../models/appointment.model");
const schedule = require("../models/schedule.model");

const doctorModel = mongoose.model("doctor");
const appointmentModel = mongoose.model("appointment");
const scheduleModel = mongoose.model("schedule");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

function setDateTime(cur, date) {
	cur.setFullYear(date.getFullYear());
	cur.setMonth(date.getMonth());
	cur.setDate(date.getDate());
	return cur;
}

exports.postAppointment = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doc_mobile_no}, async (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			var date = new Date(req.body.appointment_date_time);
			date.setHours(date.getHours() + 6);

			var schedule = await scheduleModel.findOne({_id: req.body.schedule_id}).exec();
			schedule.time_start = setDateTime(schedule.time_start, date);
			schedule.time_end = setDateTime(schedule.time_end, date);

			var query1 = {
				schedule_id: req.body.schedule_id,
				patient_mobile_no: req.mobile_no,
				status: {$lt: 2},
			};

			appointmentModel.findOne(query1, async (err, doc) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				} else if (doc) {
					res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
				} else {
					var query2 = {
						schedule_id: req.body.schedule_id,
						appointment_date_time: {$lte: schedule.time_end, $gte: schedule.time_start},
					};

					var max_collection = await appointmentModel.find(query2).sort({serial_no: -1}).limit(1).exec();

					var appointment = new appointmentModel();
					appointment.schedule_id = req.body.schedule_id;
					appointment.doc_mobile_no = req.body.doc_mobile_no;
					appointment.doc_name = docs.name;
					appointment.patient_mobile_no = req.mobile_no;
					appointment.status = 0;
					appointment.appointment_date_time = date;

					if (max_collection.length != 0) {
						appointment.serial_no = parseInt(max_collection[0].serial_no) + parseInt(1);
					} else {
						appointment.serial_no = 1;
					}

					appointment.save((err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
						} else {
							var ret = {
								serial_no: appointment.serial_no,
							};
							res.status(SUCCESS).send(ret);
						}
					});
				}
			});
		}
	});
};

exports.getAppointment = async function (req, res) {
	let st = new Date(Date.now());
	let en = new Date(Date.now());
	st.setHours(0, 0, 0, 0);
	en.setHours(23, 59, 59, 999);
	st.setHours(st.getHours() + 6);
	en.setHours(en.getHours() + 6);
	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: {$lte: en, $gte: st},
	};
	appointmentModel.find(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.getPastAppointment = async function (req, res) {
	let st = new Date(Date.now());
	st.setHours(st.getHours() + 6);
	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: {$lt: st},
	};
	var options = {
		sort: {
			appointment_date_time: -1,
		},
	};
	appointmentModel.find(query, null, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.getFutureAppointment = async function (req, res) {
	let st = new Date(Date.now());
	st.setHours(23, 59, 59, 999);
	st.setHours(st.getHours() + 6);
	var query = {
		patient_mobile_no: req.mobile_no,
		appointment_date_time: {$gt: st},
	};
	var options = {
		sort: {
			appointment_date_time: 1,
		},
	};
	appointmentModel.find(query, null, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.cancelAppointment = async function (req, res) {
	appointmentModel.deleteOne({_id: req.body.id}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs.deletedCount === 0) {
			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
		} else {
			res.status(SUCCESS).send(error_message.SUCCESS);
		}
	});
};

// exports.postAppointment = async function (req, res) {
// 	doctorModel.findOne({mobile_no: req.body.doc_mobile_no}, async (err, docs) => {
// 		if (err) {
// 			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
// 		} else if (!docs) {
// 			res.status(BAD_REQUEST).send(error_message.BAD_REQUEST);
// 		} else {
// 			var date = new Date(req.body.appointment_date_time);
// 			date.setHours(date.getHours() + 6);

// 			var schedule = await scheduleModel.findOne({_id: req.body.schedule_id}).exec();
// 			schedule.time_start = setDateTime(schedule.time_start, date);
// 			schedule.time_end = setDateTime(schedule.time_end, date);

// 			var query = {
// 				schdedule_id: req.body.schdedule_id,
// 				appointment_date_time: {$lte: schedule.time_end, $gte: schedule.time_start},
// 			};

// 			var max_collection = await appointmentModel.find(query).sort({serial_no: -1}).limit(1).exec();

// 			var appointment = new appointmentModel();
// 			appointment.schedule_id = req.body.schedule_id;
// 			appointment.doc_mobile_no = req.body.doc_mobile_no;
// 			appointment.doc_name = docs.name;
// 			appointment.patient_mobile_no = req.mobile_no;
// 			appointment.status = 0;
// 			appointment.appointment_date_time = date;

// 			if (max_collection.length != 0) {
// 				appointment.serial_no = parseInt(max_collection[0].serial_no) + parseInt(1);
// 			} else {
// 				appointment.serial_no = 1;
// 			}

// 			appointment.save((err, docs) => {
// 				if (err) {
// 					res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
// 				} else {
// 					var ret = {
// 						serial_no: appointment.serial_no,
// 					};
// 					res.status(SUCCESS).send(ret);
// 				}
// 			});
// 		}
// 	});
// };
