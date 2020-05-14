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
const path = require("path");

const multer = require("multer");
const prescriptionStorage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/prescription/");
	},
	filename: function (req, file, cb) {
		cb(null, req.body.image_title + path.extname(file.originalname));
	},
});

const uploadPrescription = multer({storage: prescriptionStorage});

const doctorDPStorage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/profile picture/doctor/");
	},
	filename: function (req, file, cb) {
		const today = new Date();
		const name = req.mobile_no + today.valueOf() + path.extname(file.originalname);
		req.fileName = name;
		cb(null, name);
	},
});
const uploadDoctorDP = multer({storage: doctorDPStorage});

router.post("/doctor/post/login", validatorMiddleWare(doctorValidator.login), doctorController.login);
router.post("/doctor/post/register", validatorMiddleWare(doctorValidator.registration), doctorController.registration);
router.post("/doctor/post/reference", validatorMiddleWare(doctorValidator.referrer), doctorMiddleware.middleware, doctorController.reference);
router.post("/doctor/edit/profile", validatorMiddleWare(doctorValidator.profileEdit), doctorMiddleware.middleware, doctorController.editDoctor);
router.post("/doctor/upload/profile_picture", doctorMiddleware.middleware, uploadDoctorDP.single("file"), doctorController.uploadDP);

router.post("/doctor/post/schedule", validatorMiddleWare(doctorValidator.postSchedule), doctorMiddleware.middleware, scheduleController.addSchedule);
router.get("/doctor/get/schedule", doctorMiddleware.middleware, scheduleController.getSchedule);
router.post("/doctor/edit/schedule", validatorMiddleWare(doctorValidator.editSchedule), doctorMiddleware.middleware, scheduleController.editSchedule);

router.post("/doctor/update/appointment", doctorMiddleware.middleware, appointmentController.updateAppointment);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, appointmentController.appointment);
router.get("/doctor/get/futureAppointment", doctorMiddleware.middleware, appointmentController.getFutureAppointment);
router.get("/doctor/get/appointmentDetail", doctorMiddleware.middleware, appointmentController.appointmentDetail);

router.get("/doctor/search/name/:name/:limit/:page", searchController.searchByName);
router.get("/doctor/search/hospital_name/:hospital_name/:limit/:page", searchController.searchByHospital);
router.get("/doctor/search/specialization/:speciality/:limit/:page", searchController.searchBySpecialization);

router.get("/doctor/list/all/:limit/:page", doctorController.doctorList);

router.post("/doctor/get/transaction", doctorMiddleware.middleware, transactionController.getTransaction);

router.post("/doctor/get/token", validatorMiddleWare(doctorValidator.token), doctorMiddleware.middleware, tokenController.getToken);

router.post(
	"/doctor/save/prescription",
	doctorMiddleware.middleware,
	uploadPrescription.single("file"),
	validatorMiddleWare(doctorValidator.postPrescription),
	prescriptionController.postPrescription
);
router.post("/doctor/get/prevPrescription", validatorMiddleWare(doctorValidator.getPreviousPrescriptions), doctorMiddleware.middleware, prescriptionController.getPreviousPrescription);

module.exports = router;
