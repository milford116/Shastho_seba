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
						msgType: "connection",
						chamberId: data.chamberId.toString(),
					};

					socket.join(data.chamberId.toString());
					socket.to(data.chamberId.toString()).emit("msg", payload);

					if (!hashmap[socket.userId]) hashmap[socket.userId] = [data.chamberId.toString()];
					else hashmap[socket.userId].push(data.chamberId.toString());

					if (cb) cb();
				}
			});
		});

		socket.on("msg", (data, cb) => {
			const chamber = data.chamberId.toString();
			let payload = {
				chamberId: chamber,
				msg: data.msg,
				msgType: "msg",
			};

			// send the whole payload in real app
			socket.to(chamber).emit("msg", payload);
		});

		socket.on("disconnect", async () => {
			console.log("Disconnected: " + socket.userId);

			if (hashmap[socket.userId]) {
				for (let i = 0; i < hashmap[socket.userId]; i++) {
					let payload = {
						msgType: "disconnect",
						chamberId: hashmap[socket.userId][i],
					};
					io.to(hashmap[socket.userId][i]).emit("msg", payload);
				}
			}
		});
	});
};

/*
--------
join
--------
app will send:
"join", object: {token, chamberid: the appointment id, type: 'patient' / 'doctor'}

when someone joins server emits:
let payload = {
	msgType: string - "connection",
	chamberId: string
};


-------
msg
-------
app will send:
"msg", object: {chamberId, msg}

when someone messages in a room, server emits:
let payload = {
	chamberId: id of the appointment,
	msg: string - actual message
	msgType: string - "msg"
};

--------
disconnect
--------
app says
when someone disconnects, server emits:
let payload = {
	msgType: "disconnect",
	chamberId: id of the appointment
};
*/
