const patientController = require("../controllers/patient.controller");
const patientMiddleware = require("../middlewares/auth.patient.middleware");
const express = require("express");
const router = express.Router();

router.post("/patient/post/login", patientController.login);
router.post("/patient/post/register", patientController.registration);

module.exports = router;
