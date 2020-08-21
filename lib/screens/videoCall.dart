import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/webrtc.dart';

import '../utils.dart';
import '../routes.dart';
import '../blocs/videoCall/callState.dart';
import '../blocs/videoCall/videoCall.dart';
import '../blocs/chamber/messenger.dart';
import '../networking/response.dart';
import '../models/appointment.dart';
import '../widgets/image.dart';

class VideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    Messenger messenger = args['messenger'];
    Appointment appointment = args['appointment'];
    return ChangeNotifierProvider(
      create: (context) => VideoCallBloc(messenger.signaling, appointment),
      builder: (context, child) {
        VideoCallBloc videoCallBloc = Provider.of<VideoCallBloc>(context);
        return StreamBuilder(
          stream: videoCallBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Response<CallState> response = snapshot.data;
              switch (response.data) {
                case CallState.Ringing:
                  return _RingingScreen(appointment);
                case CallState.Connected:
                  return _VideoCall();
                case CallState.EndCall:
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Navigator.pop(
                        context, ModalRoute.withName(appointmentDetailsScreen)),
                  );
                  break;
                default:
                  break;
              }
            }
            return Container();
          },
        );
      },
    );
  }
}

class _RingingScreen extends StatelessWidget {
  final Appointment _appointment;

  _RingingScreen(this._appointment);

  @override
  Widget build(BuildContext context) {
    VideoCallBloc videoCallBloc = Provider.of<VideoCallBloc>(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                CircleAvatar(
                  minRadius: 75.0,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 73,
                    backgroundColor: Colors.transparent,
                    // child: ShowImage(_appointment.doctor.image, 65.0),
                    child: ShowImage(_appointment.doctor.image),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  _appointment.doctor.name,
                  style: XL.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'is calling you',
                  style: L,
                ),
                Expanded(child: SizedBox()),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.call,
                        color: mint,
                        size: 30.0,
                      ),
                      color: lightMint,
                      shape: CircleBorder(),
                      onPressed: () {
                        videoCallBloc.receiveCall();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoCallBloc videoCallBloc = Provider.of<VideoCallBloc>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        children: [
          FlatButton(
            padding: EdgeInsets.all(20.0),
            child: Icon(
              Icons.call_end,
              color: red,
              size: 30.0,
            ),
            color: lightRed,
            shape: CircleBorder(),
            onPressed: () {
              videoCallBloc.endCall();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: RTCVideoView(videoCallBloc.remoteRenderer),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: RTCVideoView(videoCallBloc.localRenderer),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
