const doctorController = require("../controllers/doctor.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const express = require("express");
const router = express.Router();

router.post("/doctor/login", doctorController.login);
router.post("/doctor/register", doctorController.registration);
router.post("/doctor/reference", doctorMiddleware.middleware, doctorController.reference);
router.get("/doctor/get/appointment", doctorMiddleware, doctorController.appointment);

module.exports = router;
