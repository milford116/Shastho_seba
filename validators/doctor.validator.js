const checker = require("./checker");

module.exports.loginValidator = (data) => {
	let errors = {};

	if (!checker.isStringAndNotEmpty(data.phone)) {
		errors.phone = "phone is required";
	}
	if (!checker.isStringAndNotEmpty(data.password)) {
		errors.password = "password is required";
	}

	return {
		errors,
		isValid: checker.isEmpty(errors),
	};
};
