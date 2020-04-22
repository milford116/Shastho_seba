const doctorController = require("../controllers/doctor.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const express = require("express");
const router = express.Router();

router.post("/doctor/post/login", doctorController.login);
router.post("/doctor/post/register", doctorController.registration);
router.post("/doctor/post/reference", doctorMiddleware.middleware, doctorController.reference);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, doctorController.appointment);

module.exports = router;
