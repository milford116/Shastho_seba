const patientController = require("../controllers/patient.controller");
const patientMiddleware = require("../middlewares/auth.patient.middleware");
const express = require("express");
const router = express.Router();

router.post("/patient/post/login", patientController.login);
router.post("/patient/post/register", patientController.registration);
router.post("/patient/post/appointment", patientMiddleware.middleware, patientController.postAppointment);
router.get("/patient/get/today/appointment", patientMiddleware.middleware, patientController.getAppointment);
router.get("/patient/get/past/appointment", patientMiddleware.middleware, patientController.getPastAppointment);
router.get("/patient/get/future/appointment", patientMiddleware.middleware, patientController.getFutureAppointment);
router.post("/patient/add/transaction", patientMiddleware.middleware, patientController.addTransaction);
router.post("/patient/get/transaction", patientMiddleware.middleware, patientController.getTransaction);

module.exports = router;
