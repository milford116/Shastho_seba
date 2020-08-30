const mongoose = require("mongoose");
const transaction = require("../../models/transaction.model");
const transactionModel = mongoose.model("transaction");
const timeline = require("../../models/timeline.model");
const timelineModel = mongoose.model("timeline");

const {SUCCESS, INTERNAL_SERVER_ERROR} = require("../../errors");
const error_message = require("../../error.messages");

/**
 * @swagger
 * /doctor/get/transaction:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Transaction
 *     summary: get the transactions of a particular appointment
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               appointment_id:
 *                 type: string
 *             required:
 *               - appointment_id
 *     responses:
 *       200:
 *         description: success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: jwt token
 *                 transactions:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/transaction'
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *       400:
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
exports.getTransaction = async function (req, res) {
	transactionModel.find({appointment_id: req.body.appointment_id}, (err, docs) => {
		if (err) {
			res.status(INTERNAL_SERVER_ERROR).json({message: "Error while fetching transactions"});
		} else {
			let ret = {
				transactions: docs,
			};

			res.status(SUCCESS).json(ret);
		}
	});
};
