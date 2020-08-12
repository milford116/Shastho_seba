const doctorController = require("../controllers/doctor.controller");
const searchController = require("../controllers/search.controller");
const scheduleController = require("../controllers/doctor.schedule.controller");
const transactionController = require("../controllers/transaction.controller");
const appointmentController = require("../controllers/doctor.appointment.controller");
const prescriptionController = require("../controllers/prescription.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const validatorMiddleWare = require("../middlewares/validator.middleware");
const doctorValidator = require("../validators/doctor.validator");
const tokenController = require("../controllers/token.controller");
const express = require("express");
const router = express.Router();

router.post("/doctor/post/login", validatorMiddleWare(doctorValidator.login), doctorController.login);
router.post("/doctor/post/register", validatorMiddleWare(doctorValidator.registration), doctorController.registration);
router.post("/doctor/post/reference", validatorMiddleWare(doctorValidator.referrer), doctorMiddleware.middleware, doctorController.reference);
router.post("/doctor/edit/profile", doctorMiddleware.middleware, doctorController.editDoctor);
router.post("/doctor/upload/profile_picture", doctorMiddleware.middleware, doctorController.upload.single("file"), doctorController.uploadDP);
router.get("/doctor/get/profile", doctorMiddleware.middleware, doctorController.getProfile);
router.get("/doctor/list/all/:limit/:page", doctorController.doctorList);

router.post("/doctor/post/schedule", validatorMiddleWare(doctorValidator.postSchedule), doctorMiddleware.middleware, scheduleController.addSchedule);
router.get("/doctor/get/schedule", doctorMiddleware.middleware, scheduleController.getSchedule);
router.post("/doctor/edit/schedule", validatorMiddleWare(doctorValidator.editSchedule), doctorMiddleware.middleware, scheduleController.editSchedule);
router.get("/doctor/delete/schedule/:id", doctorMiddleware.middleware, scheduleController.deleteSchedule);
router.get("/doctor/schedule/today", doctorMiddleware.middleware, scheduleController.todaysSchedule);

router.post("/doctor/update/appointment", doctorMiddleware.middleware, appointmentController.updateAppointment);
router.get("/doctor/get/futureAppointment", doctorMiddleware.middleware, appointmentController.getFutureAppointment);
router.post("/doctor/get/appointmentDetail", doctorMiddleware.middleware, appointmentController.appointmentDetail);
router.get("/doctor/get/apointment/:id", doctorMiddleware.middleware, appointmentController.appointmentInRange);

router.post("/doctor/search", searchController.searchDoctor);
router.post("/doctor/get/transaction", doctorMiddleware.middleware, transactionController.getTransaction);
router.post("/doctor/get/token", validatorMiddleWare(doctorValidator.token), doctorMiddleware.middleware, tokenController.getToken);

router.post(
	"/doctor/save/prescription",
	doctorMiddleware.middleware,
	prescriptionController.upload.single("file"),
	validatorMiddleWare(doctorValidator.postPrescription),
	prescriptionController.postPrescription
);
router.post("/doctor/get/prevPrescription", validatorMiddleWare(doctorValidator.getPreviousPrescriptions), doctorMiddleware.middleware, prescriptionController.getPreviousPrescription);

module.exports = router;
