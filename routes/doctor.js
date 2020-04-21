const doctorController = require("../controllers/doctor.controller");
const express = require("express");
const router = express.Router();

router.post("/doctor/login", doctorController.login);
router.post("/doctor/register", doctorController.registration);
router.post("/doctor/reference", doctorController.reference); //need a middleware in this route

module.exports = router;
