const mongoose = require("mongoose");
const transaction = require("../../models/transaction.model");
const transactionModel = mongoose.model("transaction");
const appointment = require("../../models/appointment.model");
const appointmentModel = mongoose.model("appointment");
const error_message = require("../../error.messages");
const { SUCCESS, INTERNAL_SERVER_ERROR, BAD_REQUEST, DATA_NOT_FOUND } = require("../../errors");

/**
 * @swagger
 * /patient/add/transaction:
 *   post:
 *     deprecated: false
 *     security:
 *       - bearerAuth: []
 *     tags:
 *       - Transaction
 *     summary: Patient adds transaction
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               appointment_id:
 *                 type: string
 *               transaction_id:
 *                 type: string
 *               amount:
 *                 type: number
 *             required:
 *               - appointment_id
 *               - transaction_id
 *               - number
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
exports.addTransaction = async function (req, res) {
    var transaction = new transactionModel();
    transaction.appointment_id = req.body.appointment_id;
    transaction.transaction_id = req.body.transaction_id;
    transaction.amount = req.body.amount;

    transaction.save(async (err, docs) => {
        if (err) {
            res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
        } else {
            var appointment_deatils = await appointmentModel.findOne({ _id: req.body.appointment_id }).exec();

            let data = {
                due: appointment_deatils.due - req.body.amount,
                status: 1,
            };

            await appointmentModel.findOneAndUpdate({ _id: req.body.appointment_id }, data).exec();
            res.status(SUCCESS).json(error_message.SUCCESS);
        }
    });
};

/**
 * @swagger
 * /patient/get/transaction:
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
    transactionModel.find({ appointment_id: req.body.appointment_id }, (err, docs) => {
        if (err) {
            res.status(INTERNAL_SERVER_ERROR).json(error_message.INTERNAL_SERVER_ERROR);
        } else {
            let ret = {
                transactions: docs,
            };

            res.status(SUCCESS).json(ret);
        }
    });
};
