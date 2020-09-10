const express = require("express");
const router = express.Router();
const adminController = require("../controllers/admin/admin.controller");
const adminMiddleware = require("../middlewares/auth.admin.middleware");

router.post("/admin/login", adminController.login);
router.post("/admin/create", adminMiddleware.middleware, adminController.create);
router.get("/admin/logout", adminMiddleware.middleware, adminController.logout);

module.exports = router;
