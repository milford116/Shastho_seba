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
 *                   ref: '#/components/schemas/schedule'
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
 *                 description: sunday = 1, monday = 2 and so on
 *               fee:
 *                 type: number
 *             required:
 *               - time-start
 *               - time_end
 *               - day
 *               - fee
 *               - id
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 schedule:
 *                   ref: '#/components/schemas/schedule'
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

	scheduleModel.findOneAndUpdate(query, data, {new: true}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				message: error_message,
				schedule: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
};
