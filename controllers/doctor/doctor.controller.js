const mongoose = require("mongoose");
mongoose.set("useFindAndModify", false);
const doctor = require("../../models/doctor.model");
const reference = require("../../models/reference.model");
const doctorModel = mongoose.model("doctor");
const referenceModel = mongoose.model("reference");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../../errors");
const error_message = require("../../error.messages");

const path = require("path");
const multer = require("multer");

const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/profilePicture/doctor/");
	},
	filename: function (req, file, cb) {
		const today = new Date();
		const name = req.mobile_no + today.valueOf() + path.extname(file.originalname);
		req.fileName = name;
		cb(null, name);
	},
});
const upload = multer({storage});
exports.upload = upload;

/**
 * @swagger
 * /doctor/post/register/:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Doctor
 *     summary: registration of a doctor
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               mobile_no:
 *                 type: string
 *               email:
 *                 type: string
 *               institution:
 *                 type: string
 *               designation:
 *                 type: string
 *               reg_number:
 *                 type: string
 *               about_me:
 *                 type: string
 *                 description: short description about the doctor
 *               password:
 *                 type: string
 *               specialization:
 *                 type: array
 *                 items:
 *                   type: string
 *             required:
 *               - name
 *               - email
 *               - mobile_no
 *               - institution
 *               - designation
 *               - reg_number
 *               - password
 *     responses:
 *       200:
 *         description: Success
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
 *                 message:
 *                   type: string
 */
exports.registration = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (docs) {
			res.status(BAD_REQUEST).json(error_message.duplicateAcc);
		} else {
			referenceModel.findOneAndDelete({doctor: req.body.mobile_no}, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else if (!docs) {
					res.status(BAD_REQUEST).json(error_message.noRef);
				} else {
					var new_doctor = new doctorModel();
					new_doctor.name = req.body.name;
					new_doctor.email = req.body.email;
					new_doctor.mobile_no = req.body.mobile_no;
					new_doctor.institution = req.body.institution;
					new_doctor.designation = req.body.designation;
					new_doctor.reg_number = req.body.reg_number;
					new_doctor.referrer = docs.referrer;
					new_doctor.image = "https://ui-avatars.com/api/?background=2c88d9&color=fff&name=" + req.body.name;

					if (req.body.about_me) new_doctor.about_me = req.body.about_me;

					bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							new_doctor.password = hash;
							new_doctor.save((err, docs) => {
								if (err) {
									res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
								} else {
									res.status(SUCCESS).json(error_message.SUCCESS);
								}
							});
						}
					});
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/post/login:
 *   post:
 *     deprecated: false
 *     tags:
 *       - Doctor
 *     summary: logs in a doctor
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               mobile_no:
 *                 type: string
 *               password:
 *                 type: string
 *             required:
 *               - mobile_no
 *               - password
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   description: jwt token
 *                 doctor_detail:
 *                   $ref: '#/components/schemas/doctor'
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
 *       404:
 *         description: Data Not Found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.login = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json(error_message.noUserFound);
		} else {
			bcrypt.compare(req.body.password, docs.password, (err, result) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else if (!result) {
					res.status(BAD_REQUEST).json(error_message.passwordMismatch);
				} else {
					const payload = {
						mobile_no: docs.mobile_no,
					};

					const doctor_detail = docs;

					const token = jwt.sign(payload, process.env.SECRET);

					doctorModel.updateOne({mobile_no: req.body.mobile_no}, {session_token: token}, (err, docs) => {
						if (err) {
							res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
						} else {
							const ret = {
								token: token,
								doctor_detail: doctor_detail,
							};

							res.status(SUCCESS).json(ret);
						}
					});
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/post/reference:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: refer a doctor
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               doctor:
 *                 type: string
 *                 description: doctors mobile no whom we want to reffer
 *             required:
 *               - doctor
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
exports.reference = async function (req, res) {
	doctorModel.findOne({mobile_no: req.body.doctor}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (docs) {
			res.status(BAD_REQUEST).json(error_message.duplicateAcc);
		} else {
			var new_reference = new referenceModel();
			new_reference.referrer = req.mobile_no;
			new_reference.doctor = req.body.doctor;

			new_reference.save((err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).json(error_message.SUCCESS);
				}
			});
		}
	});
};

/**
 * @swagger
 * /doctor/list/all/{limit}/{page}:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: list of doctors, limit numbers per page.
 *     parameters:
 *       - in: path
 *         name: limit
 *         schema:
 *           type: integer
 *         required: true
 *         description: Numeric ID of the limit
 *       - in: path
 *         name: page
 *         schema:
 *           type: integer
 *         required: true
 *         description: Numeric ID of the page
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
 *                     type: object
 *                     properties:
 *                       _id:
 *                         type: string
 *                       name:
 *                         type: string
 *                       designation:
 *                         type: string
 *                       institution:
 *                         type: string
 *                       reg_number:
 *                         type: string
 *                       mobile_no:
 *                         type: string
 *                       email:
 *                         type: string
 *                       image:
 *                         type: string
 *                       specialization:
 *                         type: array
 *                         items:
 *                           type: string
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
exports.doctorList = async function (req, res) {
	var options = {
		page: parseInt(req.params.page, 10),
		limit: parseInt(req.params.limit, 10),
	};

	let total = await doctorModel.countDocuments({});
	let doctors = await doctorModel
		.find({})
		.limit(options.limit)
		.skip(options.limit * options.page)
		.select("_id name institution designation reg_number mobile_no email image specialization about_me")
		.exec();

	res.status(SUCCESS).json({total, doctors});
};

/**
 * @swagger
 * /doctor/edit/profile:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: Edit doctor detail
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               newDoctor:
 *                 type: object
 *                 description: send only those fields that you are updating
 *                 properties:
 *                   name:
 *                     type: string
 *                   designation:
 *                     type: string
 *                   institution:
 *                     type: string
 *                   email:
 *                     type: string
 *                   about_me:
 *                     type: string
 *                   specialization:
 *                     type: array
 *                     items:
 *                       type: string
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 doctor:
 *                   $ref: '#/components/schemas/doctor'
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
exports.editDoctor = async function (req, res) {
	let updates = req.body.newDoctor;
	doctorModel.findOneAndUpdate({mobile_no: req.mobile_no}, updates, {new: true}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else {
			let ret = {
				doctor: docs,
			};
			res.status(SUCCESS).json(ret);
		}
	});
};

/**
 * @swagger
 * /doctor/upload/profile_picture:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: Posts the profile picture of the doctor
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: profile picture of the doctor
 *             required:
 *               - file
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 doctor:
 *                   $ref: '#/components/schemas/doctor'
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
exports.uploadDP = async function (req, res) {
	const url = req.protocol + "://" + req.get("host");
	const imageName = url + "/profilePicture/doctor/" + req.fileName;

	doctorModel.findOneAndUpdate({mobile_no: req.mobile_no}, {image: imageName}, {new: true}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else res.status(SUCCESS).json({doctor: docs});
	});
};

/**
 * @swagger
 * /doctor/get/profile:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: get the profile of a doctor
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 doctor:
 *                   $ref: '#/components/schemas/doctor'
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
exports.getProfile = async function (req, res) {
	doctorModel.findOne({mobile_no: req.mobile_no}, (err, docs) => {
		if (err) res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		else {
			let ret = {
				doctor: docs,
			};

			res.status(SUCCESS).json(ret);
		}
	});
};

/**
 * @swagger
 * /doctor/logout:
 *   get:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Doctor
 *     summary: Logs out a doctor
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
 *                 message:
 *                   type: string
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       404:
 *         description: Data Not Found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.logout = async function (req, res) {
	doctorModel.findOne({mobile_no: req.mobile_no}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) {
			res.status(DATA_NOT_FOUND).json(error_message.DATA_NOT_FOUND);
		} else {
			doctorModel.updateOne({mobile_no: req.mobile_no}, {$unset: {session_token: null}}, (err, docs) => {
				if (err) {
					res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
				} else {
					res.status(SUCCESS).json(error_message.SUCCESS);
				}
			});
		}
	});
};
