const {BAD_REQUEST} = require("../errors");

module.exports = (validator) => {
	return (req, res, next) => {
		const {errors, isValid} = validator(req.body, req.params);
		if (!isValid) {
			return res.status(BAD_REQUEST).send(errors);
		}
		next();
	};
};
