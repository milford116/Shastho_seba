const helperFunctions = require("./util/helper");

exports.handleSocketIO = async function (server) {
	// socket
	const io = require("socket.io")(server);
	let hashmap = {};

	// called everytime a socket tries to connect
	io.use(async (socket, next) => {
		try {
			next();
		} catch (err) {
			console.log("socket initialization error", err);
		}
	});

	io.on("connection", async (socket) => {
		console.log("new connection", socket.id);

		socket.on("join", (data, cb) => {
			helperFunctions.jwtVerifier(data, async (err, user) => {
				if (err) console.log(err);
				else {
					socket.userId = user.detail._id;
					socket.username = user.detail.name;
					socket.userType = user.type;

					let payload = {
						chamberId: data.chamberId.toString(),
						members: [],
					};

					io.of("/")
						.in(data.chamberId.toString())
						.clients((error, clients) => {
							if (error) throw error;
							else {
								for (let i = 0; i < clients.length; i++) {
									payload.members.push(io.sockets.connected[clients[i]].userId);
								}
							}
						});

					socket.join(data.chamberId.toString());
					socket.to(data.chamberId.toString()).emit("connection", payload);

					if (cb) cb();
				}
			});
		});

		socket.on("msg", (data, cb) => {
			const chamber = data.chamberId.toString();
			socket.to(chamber).emit("msg", data);
		});

		socket.on("disconnecting", () => {
			const rooms = Object.keys(socket.rooms);
			for (let i = 0; i < rooms.length; i++) {
				let payload = {
					chamberId: rooms[i],
				};
				io.to(rooms[i]).emit("disconnect", payload);
			}
		});

		socket.on("disconnect", async () => {
			console.log("Disconnected: " + socket.userId);
		});
	});
};

/*
--------
join
--------
app will send:
"join", object: {token, chamberid: the appointment id, type: 'patient' / 'doctor'}

when someone joins server emits, "connection":
let payload = {
	chamberId: string
};


-------
msg
-------
app will send:
"msg", object: {chamberId, msg}

when someone messages in a room, server emits, "msg":
let payload = {
	chamberId: id of the appointment,
	msg: string - actual message
};

--------
disconnect
--------
app says
when someone disconnects, server emits, "disconnect":
let payload = {
	chamberId: id of the appointment
};
*/
