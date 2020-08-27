const patientController = require("../controllers/patient/patient.controller");
const appointmentController = require("../controllers/patient/patient.appointment.controller");
const transactionController = require("../controllers/patient/patient.transaction.controller");
const scheduleController = require("../controllers/patient/patient.schedule.controller");
const patientMiddleware = require("../middlewares/auth.patient.middleware");
const prescriptionController = require("../controllers/patient/patient.prescription.controller");
//const tokenController = require("../controllers/token.controller");
const timelineController = require("../controllers/patient/patient.timeline.controller");
const feedbackController = require("../controllers/patient/feedback.controller");

const express = require("express");
const router = express.Router();

router.post("/patient/post/login", patientController.login);
router.post("/patient/post/register", patientController.registration);
router.post("/patient/verify/token", patientController.verifyToken);
router.get("/patient/get/details", patientMiddleware.middleware, patientController.details);
router.post("/patient/post/logout", patientMiddleware.middleware, patientController.logout);
router.post("/patient/upload/profile_picture", patientMiddleware.middleware, patientController.upload.single("file"), patientController.uploadDP);

router.post("/patient/post/appointment", patientMiddleware.middleware, appointmentController.postAppointment);
router.post("/patient/get/appointments", patientMiddleware.middleware, appointmentController.getAppointments);
router.get("/patient/get/today/appointment", patientMiddleware.middleware, appointmentController.getAppointment);
router.get("/patient/get/past/appointment", patientMiddleware.middleware, appointmentController.getPastAppointment);
router.get("/patient/get/future/appointment", patientMiddleware.middleware, appointmentController.getFutureAppointment);
router.post("/patient/cancel/appointment", patientMiddleware.middleware, appointmentController.cancelAppointment);

router.post("/patient/add/transaction", patientMiddleware.middleware, transactionController.addTransaction);
router.post("/patient/get/transaction", patientMiddleware.middleware, transactionController.getTransaction);

router.post("/patient/get/schedule", patientMiddleware.middleware, scheduleController.getSchedule);

//router.post("/patient/set/token", patientMiddleware.middleware, tokenController.setToken);

router.post("/patient/get/timeline", patientMiddleware.middleware, timelineController.getTimeline);

router.post("/patient/post/feedback", patientMiddleware.middleware, feedbackController.postFeedback);

router.post("/patient/get/prescription", patientMiddleware.middleware, prescriptionController.getPrescription);

module.exports = router;
