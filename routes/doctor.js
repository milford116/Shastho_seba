const doctorController = require("../controllers/doctor.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const express = require("express");
const router = express.Router();

router.post("/doctor/post/login", doctorController.login);
router.post("/doctor/post/register", doctorController.registration);
router.post("/doctor/post/reference", doctorMiddleware.middleware, doctorController.reference);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, doctorController.appointment);
router.get("/doctor/search/name/:name/:limit/:page", doctorController.searchByName);
router.get("/doctor/search/hospital_name/:hospital_name/:limit/:page", doctorController.searchByHospital);
router.get("/doctor/search/specialization/:speciality/:page/:limit", doctorController.searchBySpecialization);

module.exports = router;
