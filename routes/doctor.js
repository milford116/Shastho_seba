const doctorController = require("../controllers/doctor.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const express = require("express");
const router = express.Router();

router.post("/doctor/post/login", doctorController.login);
router.post("/doctor/post/register", doctorController.registration);
router.post("/doctor/post/reference", doctorMiddleware.middleware, doctorController.reference);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, doctorController.appointment);
router.get("/doctor/search/name/:name/:limit/:page", doctorController.searchByName); //example to use pagination limit: (num of documents show per page), page: (which page user wants to see)
router.get("/doctor/search/email/:email", doctorController.searchByEmail);
router.get("/doctor/search/mobile_no/:mobile_no", doctorController.searchByMobileNo);
router.get("/doctor/search/hospital_name/:hospital_name", doctorController.searchByHospital);

module.exports = router;
