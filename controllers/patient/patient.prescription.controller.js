const mongoose = require("mongoose");
const prescription = require("../../models/prescription.model");
const prescriptionModel = mongoose.model("prescription");
const error_message = require("../../error.messages");
const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND } = require("../../errors");

exports.getPrescription = async function (req, res) {
    prescriptionModel.find({ appointment_id: req.body.appointment_id }, (err, docs) => {
        if (err) {
            res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
        } else {
            let ret = {
                prescription: docs,
            };

            res.status(SUCCESS).json(ret);
        }
    });
};
