const helperFunctions = require("./util/helper");

exports.handleSocketIO = async function (server) {
	// socket
	const io = require("socket.io")(server);

	// called everytime a socket tries to connect
	io.use(async (socket, next) => {
		try {
			next();
		} catch (err) {
			console.log("socket initialization error", err);
		}
	});

	io.on("connection", async (socket) => {
		socket.on("join", (data, cb) => {
			helperFunctions.jwtVerifier(data.token, async (err, user) => {
				if (err) console.log(err);
				else {
					// const webinar = await Webinar.findById(data.webinarId);
					// const seminarRoom = webinar._id.toString() + '_seminar';
					// const modRoom = webinar._id.toString() + '_mod';
					// socket.join(seminarRoom);
				}
			});
		});

		socket.on("msg", (data, cb) => {
			const chamber = data.chamberId.toString();
			io.to(chamber).emit(data.message);
		});
	});
};
