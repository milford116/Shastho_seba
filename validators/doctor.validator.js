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
