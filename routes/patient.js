const patientController = require("../controllers/patient.controller");
const express = require('express');
const router = express.Router();

router.post('/patient/login', patientController.login);
router.post('/patient/register', patientController.registration);

module.exports = router;