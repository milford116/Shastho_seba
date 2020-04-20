const patient = require("../models/patient.model");
const mongoose = require("mongoose");
const patientModel = mongoose.model("patient");
const bcrypt = require("bcrypt");
const dotenv = require("dotenv");

exports.registration = async function(req, res) 
{
    patientModel.findOne({mobile_no: req.body.mobile_no}, (err, docs)=>
    {
        if (err)
            res.send(err);
        else if (docs)
            res.send("This mobile number has been already registered");
        else 
        {
            var new_patient = new patientModel();
            new_patient.mobile_no = req.body.mobile_no;
            new_patient.name = req.body.name;
            new_patient.age = req.body.age;

            bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), (err, hash)=>
            {
                if (err)
                    res.send(err);
                else
                {
                    new_patient.password = hash;

                    new_patient.save((err, doc)=>
                    {
                        res.send(doc);
                    });
                }
            });
        }
    });
}