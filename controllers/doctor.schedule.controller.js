const mongoose = require("mongoose");
const schedule = require("../models/schedule.model");
const scheduleModel = mongoose.model("schedule");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");

/**
 * @swagger
 * /doctor/post/schedule:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Schedule
 *     summary: adds schedule
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               time_start:
 *                 type: string
 *                 format: date-time
 *               time_end:
 *                 type: string
 *                 format: date-time
 *               day:
 *                 type: number
 *                 description: sunday = 1, monday = 2 and so on
 *               fee:
 *                 type: number
 *             required:
 *               - time-start
 *               - time_end
 *               - day
 *               - fee
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 schedule:
 *                   $ref: '#/components/schemas/schedule'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.addSchedule = async function (req, res) {
	var st = new Date(req.body.time_start);
	var en = new Date(req.body.time_end);

	// the front-end sends time that is not GMT+6
	// st.setHours(st.getHours() + 6);
	// en.setHours(en.getHours() + 6);

	// date doesn't matter so fixing a particular date
	st.setDate(1), st.setMonth(1), st.setFullYear(2000);
	en.setDate(1), en.setMonth(1), en.setFullYear(2000);

	/*
  	https://stackoverflow.com/questions/13272824/combine-two-or-queries-with-and-in-mongoose
		time_start st-en time_end : old: 9-12, new: 10-11 
		st time_start-time_end en : old: 9-12, new: 8-13
		st time-start en time_end : old: 9-12, new: 8-11
		time_start st time_end en : old: 9-12, new: 10:13
		accepted: 7-8, anything starting after 12
		old: 9-12. new: 8-9
		old 9-12, new 12-13
		old 9-12, new: 0-9
	*/
	var query = {
		doc_mobile_no: req.mobile_no,
		$or: [
			{$and: [{time_start: {$lt: st, $lt: en}}, {time_end: {$gt: st, $gt: en}}]},
			{$and: [{time_start: {$gt: st, $lt: en}}, {time_end: {$gt: st, $lt: en}}]},
			{$and: [{time_start: {$gt: st, $lt: en}}, {time_end: {$gt: st, $gt: en}}]},
			{$and: [{time_start: {$lt: st, $lt: en}}, {time_end: {$gt: st, $lt: en}}]},
		],
		day: req.body.day,
	};

	scheduleModel.findOne(query, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).json({message: "schedule clashes with existing schedule"});
		} else {
			var new_schedule = new scheduleModel();
			new_schedule.doc_mobile_no = req.mobile_no;
			new_schedule.time_start = st;
			new_schedule.time_end = en;
			new_schedule.day = req.body.day;
			new_schedule.fee = req.body.fee;

			new_schedule.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).json({schedule: docs});
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/get/schedule:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Schedule
 *     summary: returns all the upcoming schedule
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 schedules:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/schedule'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.getSchedule = async function (req, res) {
	scheduleModel.find({doc_mobile_no: req.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				schedules: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
};

/**
 * @swagger
 * /doctor/edit/schedule:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Schedule
 *     summary: edits schedule
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id:
 *                 type: string
 *               time_start:
 *                 type: string
 *                 format: date-time
 *               time_end:
 *                 type: string
 *                 format: date-time
 *               day:
 *                 type: number
 *                 description: monday = 1 and so on
 *               fee:
 *                 type: number
 *             required:
 *               - id
 *               - time_start
 *               - time_end
 *               - day
 *               - fee
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 schedule:
 *                   $ref: '#/components/schemas/schedule'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.editSchedule = async function (req, res) {
	var st = new Date(req.body.time_start);
	var en = new Date(req.body.time_end);

	// st.setHours(st.getHours() + 6);
	// en.setHours(en.getHours() + 6);
	// date doesn't matter so fixing a particular date
	st.setDate(1), st.setMonth(1), st.setFullYear(2000);
	en.setDate(1), en.setMonth(1), en.setFullYear(2000);

	var query = {
		doc_mobile_no: req.mobile_no,
		$or: [
			{$and: [{time_start: {$lt: st, $lt: en}}, {time_end: {$gt: st, $gt: en}}]},
			{$and: [{time_start: {$gt: st, $lt: en}}, {time_end: {$gt: st, $lt: en}}]},
			{$and: [{time_start: {$gt: st, $lt: en}}, {time_end: {$gt: st, $gt: en}}]},
			{$and: [{time_start: {$lt: st, $lt: en}}, {time_end: {$gt: st, $lt: en}}]},
		],
		day: req.body.day,
		_id: {$ne: mongoose.Types.ObjectId(req.body.id)},
	};

	let data = {
		time_start: st,
		time_end: en,
		day: req.body.day,
		fee: req.body.fee,
	};

	let clash = await scheduleModel.find(query).exec();
	if (clash && clash.length) res.status(BAD_REQUEST).json({message: "schedule clashes with current schedules"});
	else {
		scheduleModel.findOneAndUpdate({_id: req.body.id}, data, {new: true}, (err, docs) => {
			console.log(err, docs);
			if (err) {
				res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
			} else {
				let ret = {
					schedule: docs,
				};
				res.status(SUCCESS).json(ret);
			}
		});
	}
};

/**
 * @swagger
 * /doctor/delete/schedule/{id}:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Schedule
 *     summary: Delete a schedule
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: Numeric ID of the schedule
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 *       404:
 *         description: Data Not Found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 */
exports.deleteSchedule = async function (req, res) {
	let id = req.params.id;
	let schedule = await scheduleModel.findById(id);

	if (!schedule) res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
	else {
		scheduleModel.deleteOne({_id: id}, (err, docs) => {
			if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
			else res.status(SUCCESS).json(error_message.SUCCESS);
		});
	}
};

/**
 * @swagger
 * /doctor/schedule/today:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Schedule
 *     summary: Gets all the schedule of today
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 schedules:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/schedule'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 msg:
 *                   type: string
 */
exports.todaysSchedule = async function (req, res) {
	var date = new Date();
	var query = {
		doc_mobile_no: req.mobile_no,
		day: date.getDay() === 0 ? 7 : date.getDay(),
	};

	let schedules = await scheduleModel.find(query).exec();
	res.status(SUCCESS).json({schedules});
};
