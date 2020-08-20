const mongoose = require("mongoose");
const csv = require("convert-csv-to-json");

const medicine = require("../../models/medicine.model");
const medicineModel = mongoose.model("medicine");

const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND } = require("../../errors");
const error_message = require("../../error.messages");

exports.populateMedicine = async function (req, res) {
    let json = csv.fieldDelimiter(',').getJsonFromCsv("./controllers/doctor/medicine.csv");

    for (let i = 0; i < 10; ++i) {
        console.log(json[i].Generic);
    }
};