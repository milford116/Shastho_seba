const express = require("express");
const router = express.Router();
const adminController = require("../controllers/admin/admin.controller");
const doctorController = require("../controllers/admin/doctor.controller");
const adminMiddleware = require("../middlewares/auth.admin.middleware");

router.post("/admin/login", adminController.login);
router.post("/admin/create", adminMiddleware.middleware, adminController.create);
router.get("/admin/logout", adminMiddleware.middleware, adminController.logout);

router.post("/admin/get/doctors", adminMiddleware.middleware, doctorController.getAllDoctor);

module.exports = router;
