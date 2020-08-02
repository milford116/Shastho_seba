const swaggerJSDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");

const options = {
	swaggerDefinition: {
		info: {
			title: "ShashthoSheba-Backend-V1",
			version: "2.0.0",
			description: "An online doctor consultation system",
			license: {
				name: "MIT",
				url: "https://choosealicense.com/licenses/mit/",
			},
			contact: {
				name: "Team-ShashthoSheba",
				url: "",
				email: "waqar.hassan866@gmail.com",
			},
		},

		components: {
			securitySchemes: {
				bearerAuth: {
					description: "Run the /user/login api, and cop the JWT token from the response",
					type: "apiKey",
					name: "Authorization",
					in: "header",
				},
			},
		},
		openapi: "3.0.0",
		servers: [{url: "http://localhost:" + process.env.PORT + "/"}],
		responses: {
			UnauthorizedError: {
				description: "Access token is missing or invalid",
			},
		},

		basePath: "http://localhost:" + process.env.PORT + "/",
		paths: {},
		definitions: {},
		responses: {},
		parameters: {},
	},
	apis: ["./models/*.js", "./controllers/doctor/*.js"],
	explorer: true,
};

const swaggerDocs = swaggerJSDoc(options);

const setSwagger = (app) => {
	app.use(
		"/api-docs",
		swaggerUi.serve,
		swaggerUi.setup(swaggerDocs, {
			explorer: true,
		})
	);
};

module.exports = setSwagger;
