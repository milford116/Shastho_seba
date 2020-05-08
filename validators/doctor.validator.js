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
