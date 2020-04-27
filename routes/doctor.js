const doctorController = require("../controllers/doctor.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const express = require("express");
const router = express.Router();

router.post("/doctor/post/login", doctorController.login);
router.post("/doctor/post/register", doctorController.registration);
router.post("/doctor/post/reference", doctorMiddleware.middleware, doctorController.reference);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, doctorController.appointment);
router.get("/doctor/get/futureAppointment", doctorMiddleware.middleware, doctorController.getFutureAppointment);
router.get("/doctor/get/appointmentDetail", doctorMiddleware.middleware, doctorController.appointmentDetail);
router.get("/doctor/search/name/:name/:limit/:page", doctorController.searchByName);
router.get("/doctor/search/hospital_name/:hospital_name/:limit/:page", doctorController.searchByHospital);
router.get("/doctor/search/specialization/:speciality/:limit/:page", doctorController.searchBySpecialization);
router.get("/doctor/list/all/:limit/:page", doctorController.doctorList);

module.exports = router;
