"use strict";

var mongoose = require("mongoose");

var doctor = require("../models/doctor.model");

var reference = require("../models/reference.model");

var appointment = require("../models/appointment.model");

var doctorModel = mongoose.model("doctor");
var referenceModel = mongoose.model("reference");
var appointmentModel = mongoose.model("appointment");

var bcrypt = require("bcrypt");

var jwt = require("jsonwebtoken");

var _require = require("../errors"),
    SUCCESS = _require.SUCCESS,
    INTERNAL_SERVER_ERROR = _require.INTERNAL_SERVER_ERROR,
    BAD_REQUEST = _require.BAD_REQUEST,
    DATA_NOT_FOUND = _require.DATA_NOT_FOUND;

exports.registration = function _callee(req, res) {
  return regeneratorRuntime.async(function _callee$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          doctorModel.findOne({
            mobile_no: req.body.mobile_no
          }, function (err, docs) {
            if (docs) {
              res.status(BAD_REQUEST).send("An account with this mobile no. already exists");
            } else {
              referenceModel.findOneAndDelete({
                doctor: req.body.mobile_no
              }, function (err, docs) {
                if (err) {
                  res.status(BAD_REQUEST).send("No referreral found for this mobile no");
                } else {
                  var new_doctor = new doctorModel();
                  new_doctor.name = req.body.name;
                  new_doctor.email = req.body.email;
                  new_doctor.mobile_no = req.body.mobile_no;
                  new_doctor.institution = req.body.institution;
                  new_doctor.designation = req.body.designation;
                  new_doctor.reg_number = req.body.reg_number;
                  new_doctor.referrer = docs.referrer;
                  var payload = {
                    mobile_no: new_doctor.mobile_no,
                    name: new_doctor.name,
                    reg_number: new_doctor.reg_number
                  };
                  new_doctor.session_token = jwt.sign(payload, process.env.SECRET);
                  bcrypt.hash(req.body.password, parseInt(process.env.SALT_ROUNDS, 10), function (err, hash) {
                    if (err) {
                      res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
                    } else {
                      new_doctor.password = hash;
                      new_doctor.save(function (err, docs) {
                        if (err) {
                          res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
                        } else {
                          res.status(SUCCESS).send(token);
                        }
                      });
                    }
                  });
                }
              });
            }
          });

        case 1:
        case "end":
          return _context.stop();
      }
    }
  });
};

exports.login = function _callee2(req, res) {
  return regeneratorRuntime.async(function _callee2$(_context2) {
    while (1) {
      switch (_context2.prev = _context2.next) {
        case 0:
          doctorModel.findOne({
            mobile_no: req.body.mobile_no
          }, function (err, docs) {
            if (err) {
              res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
            } else if (!docs) {
              res.status(DATA_NOT_FOUND).send("No such user found");
            } else {
              bcrypt.compare(req.body.password, docs.password, function (err, result) {
                if (err) {
                  res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
                } else {
                  var payload = {
                    mobile_no: docs.mobile_no,
                    name: docs.name,
                    reg_number: docs.reg_number
                  };

                  var _token = jwt.sign(payload, process.env.SECRET);

                  doctorModel.updateOne({
                    mobile_no: req.body.mobile_no
                  }, {
                    session_token: _token
                  }, function (err, docs) {
                    if (err) {
                      res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
                    } else {
                      res.status(SUCCESS).send(_token);
                    }
                  });
                }
              });
            }
          });

        case 1:
        case "end":
          return _context2.stop();
      }
    }
  });
};

exports.reference = function _callee3(req, res) {
  return regeneratorRuntime.async(function _callee3$(_context3) {
    while (1) {
      switch (_context3.prev = _context3.next) {
        case 0:
          doctorModel.findOne({
            mobile_no: req.body.doctor
          }, function (err, docs) {
            if (err) {
              res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
            } else if (docs) {
              res.status(BAD_REQUEST).send("The doctor has already registered");
            } else {
              var new_reference = new referenceModel();
              new_reference.referrer = req.mobile_no;
              new_reference.doctor = req.body.doctor;
              new_reference.save(function (err, docs) {
                if (err) {
                  res.status(INTERNAL_SERVER_ERROR).send("Something went wrong");
                } else {
                  res.status(SUCCESS).send("Successfully referred");
                }
              });
            }
          });

        case 1:
        case "end":
          return _context3.stop();
      }
    }
  });
};

exports.appointment = function _callee4(req, res) {
  var today;
  return regeneratorRuntime.async(function _callee4$(_context4) {
    while (1) {
      switch (_context4.prev = _context4.next) {
        case 0:
          today = new Date();
          appointmentModel.find({
            doc_mobile_no: req.mobile_no,
            appointment_date: today
          }, function (err, docs) {
            if (err) {
              res.status(INTERNAL_SERVER_ERROR).send("Internal server error");
            } else {
              res.status(SUCCESS).send(docs);
            }
          });

        case 2:
        case "end":
          return _context4.stop();
      }
    }
  });
};