"use strict";

var doctorController = require("../controllers/doctor.controller");

var doctorMiddleware = require("../middlewares/auth.doctor.middleware");

var express = require("express");

var router = express.Router();
router.post("/doctor/post/login", doctorController.login);
router.post("/doctor/post/register", doctorController.registration);
router.post("/doctor/post/reference", doctorMiddleware.middleware, doctorController.reference);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, doctorController.appointment);
router.get("/doctor/search/name", doctorController.searchByName);
router.get("/doctor/search/email", doctorController.searchByEmail);
router.get("/doctor/search/phone_no", doctorController.searchByPhoneNo);
router.get("/doctor/search/hospital_name", doctorController.searchByHospital);
router.get("/doctor/search/speciality", doctorController.searchBySpeciality);
module.exports = router;