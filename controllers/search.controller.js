const mongoose = require("mongoose");
const doctor = require("../models/doctor.model");
const doctorModel = mongoose.model("doctor");
const {SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND} = require("../errors");

exports.searchByName = async function (req, res) {
	var options = {
		page: parseInt(req.params.page, 10),
		limit: parseInt(req.params.limit, 10),
	};

	doctorModel.paginate({name: {$regex: req.params.name, $options: "i"}}, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.searchByHospital = async function (req, res) {
	var options = {
		page: parseInt(req.params.page, 10),
		limit: parseInt(req.params.limit, 10),
	};

	doctorModel.paginate({institution: {$regex: req.params.hospital_name, $options: "i"}}, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};

exports.searchBySpecialization = async function (req, res) {
	let re = new RegExp("" + req.params.speciality, "i");

	var query = {
		specialization: {$in: re},
	};

	var options = {
		page: parseInt(req.params.page, 10),
		limit: parseInt(req.params.limit, 10),
	};

	doctorModel.paginate(query, options, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).send("something went wrong");
		} else {
			res.status(SUCCESS).send(docs);
		}
	});
};
