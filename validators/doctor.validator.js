const validator = require("validator");
const checker = require("./checker");

module.exports.login = (data) => {
	let errors = {};

	if (validator.isEmpty(data.mobile_no)) {
		errors.phone = "mobile number is required";
	}

	if (validator.isEmpty(data.password)) {
		errors.password = "password is required";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.registration = (data) => {
	let errors = {};

	if (validator.isEmpty(data.mobile_no)) {
		errors.mobile_no = "mobile number is required";
	}

	if (validator.isEmpty(data.password)) {
		errors.password = "password is required";
	}

	if (validator.isEmpty(data.name)) {
		errors.name = "name is required";
	}

	if (validator.isEmpty(data.institution)) {
		errors.institution = "institution is required";
	}

	if (validator.isEmpty(data.designation)) {
		errors.designation = "designation is required";
	}

	if (validator.isEmpty(data.reg_number)) {
		errors.reg_number = "registration number is required";
	}

	if (!validator.isEmail(data.email)) {
		errors.email = "invalid email";
	}

	if (!checker.bangladeshiPhone(data.mobile_no)) {
		errors.mobile_no = "not a valid Bangladeshi phone number";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.referrer = (data) => {
	let errors = {};

	if (validator.isEmpty(data.referrer)) {
		errors.referrer = "mobile number of referrer is required";
	}

	if (validator.isEmpty(data.doctor)) {
		errors.doctor = "mobile number of the doctor you are referring is required";
	}

	if (!checker.bangladeshiPhone(data.referrer)) {
		errors.referrer = "mobile number of referrer is not valid";
	}

	if (!checker.bangladeshiPhone(data.doctor)) {
		errors.doctor = "mobile number of the doctor you are referring is not valid";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.profileEdit = (data) => {
	let errors = {};

	if (!validator.isMongoId(data.doctor_id)) {
		errors.doctor_id = "invalid doctor id";
	}

	if (data.updates.name !== undefined && validator.isEmpty(data.updates.name)) {
		errors.name = "name cannot be empty";
	}

	if (data.updates.institution !== undefined && validator.isEmpty(data.updates.institution)) {
		errors.institution = "institution cannot be empty";
	}

	if (data.updates.designation !== undefined && validator.isEmpty(data.updates.designation)) {
		errors.designation = "designation is required";
	}

	if (data.updates.email !== undefined && !validator.isEmail(data.updates.email)) {
		errors.email = "invalid email";
	}

	if (data.updates.email !== undefined && !validator.isEmail(data.updates.email)) {
		errors.email = "invalid email";
	}

	if (data.updates.specialization !== undefined && !checker.isArrayAndNotEmpty(data.updates.specialization)) {
		errors.specialization = "specialization cannot be empty";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.token = (data) => {
	let errors = {};

	if (validator.isEmpty(data.mobile_no)) {
		errors.mobile_no = "mobile number is required";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.postSchedule = (data) => {
	let errors = {};

	if (!validator.isMongoId(data.id)) {
		errors.id = "invalid schedule id";
	}

	if (!checker.isDate(data.time_start)) {
		errors.time_start = "starting time is required";
	}

	if (!checker.isDate(data.time_end)) {
		errors.time_end = "ending time is required";
	}

	if (validator.isEmpty(data.day)) {
		errors.day = "day is required";
	}

	if (validator.isEmpty(data.fee)) {
		errors.fee = "fee is required";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.editSchedule = (data) => {
	let errors = {};

	if (validator.isEmpty(data.doc_mobile_no)) {
		errors.doc_mobile_no = "mobile number is required";
	}

	if (!checker.isDate(data.time_start)) {
		errors.time_start = "starting time is required";
	}

	if (!checker.isDate(data.time_end)) {
		errors.time_end = "ending time is required";
	}

	if (validator.isEmpty(data.day)) {
		errors.day = "day is required";
	}

	if (validator.isEmpty(data.fee)) {
		errors.fee = "fee is required";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.getAppointment = (data) => {
	let errors = {};

	if (!validator.isMongoId(data.appointment_id)) {
		errors.appointment_id = "invaid id";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.postPrescription = (data) => {
	let errors = {};

	if (!validator.isMongoId(data.id)) {
		errors.id = "invaid id";
	}

	if (validator.isEmpty(data.image_title)) {
		errors.image_title = "image title should not be empty";
	}

	// if (checker.isEmpty(data.file)) {
	// 	errors.file = "prescription not sent!!!";
	// }

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};

module.exports.getTransaction = (data) => {
	let errors = {};

	if (!validator.isMongoId(data.appointment_id)) {
		errors.appointment_id = "invaid id";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};
