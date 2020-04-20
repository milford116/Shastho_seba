const express = require('express');
const router = express.router();
const mongoose = require('mongoose');
const doctorModel = mongoose.model('../models/doctor.model.js');
const md5 = require('md5');
