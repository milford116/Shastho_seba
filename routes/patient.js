const patientController = require("../controllers/patient.controller");
const patientMiddleware = require("../middlewares/auth.patient.middleware");
const express = require("express");
const router = express.Router();

router.post("/patient/post/login", patientController.login);
router.post("/patient/post/register", patientController.registration);
router.post("/patient/post/appointment", patientMiddleware.middleware, patientController.postAppointment);
router.post("/patient/get/appointment", patientMiddleware.middleware, patientController.getAppointment);

module.exports = router;
