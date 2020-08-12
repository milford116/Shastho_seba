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
			helperFunctions.jwtVerifier(data, async (err, user) => {
				if (err) console.log(err);
				else {
					socket.userId = user.detail._id;
					socket.username = user.detail.name;
					socket.userType = user.type;

					console.log(user.detail.name, "has joined");
					socket.join(data.chamberId.toString());
					if (cb) cb();
				}
			});
		});

		socket.on("msg", (data, cb) => {
			const chamber = data.chamberId.toString();
			let payload = {
				userId: socket.userId,
				username: socket.username,
				userType: socket.userType,
				msg: data.msg,
			};

			// send the whole payload in real app
			console.log(payload.username, " says ", payload.msg);
			io.to(chamber).emit(payload.msg);
		});

		socket.on("disconnect", async () => {
			console.log("Disconnected: " + socket.userId);

			// io.to(socket.userId).emit('message', {
			// 	user: 'Admin',
			// 	text: `${socket.username} has left.`,
			// });
		});
	});
};
