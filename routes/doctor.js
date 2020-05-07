const doctorController = require("../controllers/doctor.controller");
const searchController = require("../controllers/search.controller");
const scheduleController = require("../controllers/doctor.schedule.controller");
const transactionController = require("../controllers/transaction.controller");
const appointmentController = require("../controllers/doctor.appointment.controller");
const prescriptionController = require("../controllers/prescription.controller");
const doctorMiddleware = require("../middlewares/auth.doctor.middleware");
const tokenController = require("../controllers/token.controller");
const express = require("express");
const router = express.Router();

const multer = require("multer");
const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./storage/prescription/");
	},
	filename: function (req, file, cb) {
		cb(null, file.originalname);
	},
});

const upload = multer({storage: storage});

router.post("/doctor/post/login", doctorController.login);
router.post("/doctor/post/register", doctorController.registration);
router.post("/doctor/post/reference", doctorMiddleware.middleware, doctorController.reference);
router.post("/doctor/post/schedule", doctorMiddleware.middleware, scheduleController.addSchedule);
router.post("/doctor/update/appointment", doctorMiddleware.middleware, appointmentController.updateAppointment);
router.get("/doctor/get/appointment", doctorMiddleware.middleware, appointmentController.appointment);
router.get("/doctor/get/futureAppointment", doctorMiddleware.middleware, appointmentController.getFutureAppointment);
router.get("/doctor/get/appointmentDetail", doctorMiddleware.middleware, appointmentController.appointmentDetail);
router.get("/doctor/search/name/:name/:limit/:page", searchController.searchByName);
router.get("/doctor/search/hospital_name/:hospital_name/:limit/:page", searchController.searchByHospital);
router.get("/doctor/search/specialization/:speciality/:limit/:page", searchController.searchBySpecialization);
router.get("/doctor/list/all/:limit/:page", doctorController.doctorList);
router.get("/doctor/get/schedule", doctorMiddleware.middleware, scheduleController.getSchedule);
router.post("/doctor/get/transaction", doctorMiddleware.middleware, transactionController.getTransaction);
router.post("/doctor/edit/profile", doctorMiddleware.middleware, doctorController.editDoctor);
router.post("/doctor/edit/schedule", doctorMiddleware.middleware, scheduleController.editSchedule);
router.post("/doctor/get/token", doctorMiddleware.middleware, tokenController.getToken);

router.post("/doctor/save/prescription", doctorMiddleware.middleware, upload.single("file"), prescriptionController.postPrescription);

module.exports = router;
