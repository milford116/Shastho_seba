const mongoose = require("mongoose");

const appointment = require("../models/appointment.model");
const appointmentModel = mongoose.model("appointment");

const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");
const error_message = require("../error.messages");
const multer = require("multer");
const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/prescription/");
	},
	filename: function (req, file, cb) {
		cb(null, req.body.image_title + ".png");
	},
});

const upload = multer({storage: storage});

exports.postPrescription = async function (req, res) {
	const image_title = "/prescription/" + req.body.image_title + ".png";

	appointmentModel.find({_id: req.body.id}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
		} else if (!docs) res.status(DATA_NOT_FOUND).send(error_message.DATA_NOT_FOUND);
		else {
			// upload the image

			console.log(image_title);
			appointmentModel.updateOne({_id: req.body.id}, {prescription_img: image_title}, (err, docs) => {
				if (err) res.status(INTERNAL_SERVER_ERROR).send(error_message.INTERNAL_SERVER_ERROR);
				else res.status(SUCCESS).send(error_message.SUCCESS);
			});
		}
	});
};
