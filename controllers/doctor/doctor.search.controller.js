const mongoose = require("mongoose");
const doctor = require("../../models/doctor.model");
const doctorModel = mongoose.model("doctor");
const {SUCCESS, INTERNAL_SERVER_ERROR} = require("../../errors");
const error_message = require("../../error.messages");

/**
 * @swagger
 * /doctor/search:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Search
 *     summary: search doctor using either doctorname, hospital_name or specialization
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               limit:
 *                 type: number
 *               page:
 *                 type: number
 *               doctor_name:
 *                 type: string
 *               hospital_name:
 *                 type: string
 *               specialization:
 *                 type: string
 *             required:
 *               - limit
 *               - password
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 doctors:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/doctor'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.searchDoctor = async function (req, res) {
	let data = req.body;
	let query = {};

	if (data.doctor_name) {
		query = {name: {$regex: data.doctor_name, $options: "i"}};
	} else if (data.hospital_name) {
		query = {institution: {$regex: data.hospital_name, $options: "i"}};
	} else {
		let re = new RegExp("" + data.specialization, "i");
		query = {
			specialization: {$in: re},
		};
	}

	await doctorModel
		.find(query)
		.limit(data.limit)
		.skip(data.limit * data.skip)
		.select("_id name institution designation reg_number mobile_no email image specialization about_me")
		.exec((err, docs) => {
			if (err) res.status(INTERNAL_SERVER_ERROR).json({message: "Error while searching doctor"});
			else {
				let ret = {
					doctors: docs,
				};
				res.status(SUCCESS).send(ret);
			}
		});
};
