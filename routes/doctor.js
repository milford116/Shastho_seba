const doctorController = require("../controllers/doctor.controller");
const express = require("express");
const router = express.Router();

router.post("/doctor/login", doctorController.login);
router.post("/doctor/register", doctorController.registration);

module.exports = router;
