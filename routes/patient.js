const patientController = require("../controllers/patient.controller");
const appointmentController = require("../controllers/patient.appointment.controller");
const transactionController = require("../controllers/transaction.controller");
const patientMiddleware = require("../middlewares/auth.patient.middleware");
const express = require("express");
const router = express.Router();

router.post("/patient/post/login", patientController.login);
router.post("/patient/post/register", patientController.registration);
router.post("/patient/post/appointment", patientMiddleware.middleware, appointmentController.postAppointment);
router.get("/patient/get/today/appointment", patientMiddleware.middleware, appointmentController.getAppointment);
router.get("/patient/get/past/appointment", patientMiddleware.middleware, appointmentController.getPastAppointment);
router.get("/patient/get/future/appointment", patientMiddleware.middleware, appointmentController.getFutureAppointment);
router.post("/patient/add/transaction", patientMiddleware.middleware, transactionController.addTransaction);
router.post("/patient/get/transaction", patientMiddleware.middleware, transactionController.getTransaction);

module.exports = router;
