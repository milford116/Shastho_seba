const {BAD_REQUEST} = require("../errors");

module.exports = (validator) => {
	return (req, res, next) => {
		console.log("value: ", process.env.validateInput);
		if (process.env.validateInput === "1") {
			console.log("validating");
			const {errors, isValid} = validator(req.body, req.params);
			if (!isValid) {
				return res.status(BAD_REQUEST).send(errors);
			}
			next();
		} else next();
	};
};
