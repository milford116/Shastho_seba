const patientController = require("../controllers/patient.controller");
const patientMiddleware = require("../middlewares/auth.patient.middleware");
const express = require("express");
const router = express.Router();

router.post("/patient/login", patientController.login);
router.post("/patient/register", patientController.registration);
router.get("/patient/refer", patientMiddleware.middleware, patientController.editProfile);

module.exports = router;
