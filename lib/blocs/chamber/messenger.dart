import 'package:socket_io_client/socket_io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signaling.dart';
import 'chamber.dart';
import '../../models/appointment.dart';

typedef void CallReceiveCallback();

class Messenger {
  String _url;
  Socket _socket;
  Signaling signaling;
  CallReceiveCallback onCallReceive;
  ChamberBloc _chamberBloc;

  Messenger(this._url, this._chamberBloc);

  void init(String id) async {
    _socket = io(_url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    signaling = Signaling();

    _socket.connect();

    _socket.on(
      'connect',
      (_) async {
        print('connect');
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String jwt = sharedPreferences.getString('jwt');
        print('join');
        _socket.emit(
          'join',
          {
            'token': 'Bearer ' + jwt,
            'type': 'patient',
            'chamberId': id,
          },
        );
      },
    );

    _socket.on('msg', (data) {
      signaling.onMessage(data);
    });

    signaling.onSendMessage = (dynamic data) {
      print('sending');
      print(data);
      _socket.emit('msg', data);
    };

    _socket.on('connection', (data) {
      print('connection');
    });

    _socket.on('disconnect', (data) {
      print('disconnect');
    });

    _socket.on('old_connection', (data) {
      print('old_connection');
      _chamberBloc.doctorStatus = true;
    });

    signaling.onCallReceive = () => onCallReceive();
    // signaling.onStateChange = (SignalingState state, [String from]) async {
    //   switch (state) {
    //     case SignalingState.CallStateNew:
    //       print('********************connecting************************');
    //       break;
    //     case SignalingState.CallStateInvite:
    //       onCallReceive();
    //       break;
    //     default:
    //       break;
    //   print('************************invite************************');
    //   _signaling.replyToInvitation(
    //     await showDialog<bool>(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           title: Text('$from is Calling'),
    //           actions: <Widget>[
    //             ButtonBar(
    //               children: <Widget>[
    //                 OutlineButton(
    //                   child: Text('Accept'),
    //                   onPressed: () => Navigator.pop<bool>(context, true),
    //                 ),
    //                 OutlineButton(
    //                   child: Text('Reject'),
    //                   onPressed: () => Navigator.pop<bool>(context, false),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         );
    //       },
    //     ),
    //     from,
    //   );
    //   break;
    // case SignalingState.CallStateBye:
    //   this.setState(() {
    //     _localRenderer.srcObject = null;
    //     _remoteRenderer.srcObject = null;
    //     _inCalling = false;
    //   });
    //   break;
    // case SignalingState.CallStateCancel:
    //   print('************************canceled************************');
    //   break;
    // case SignalingState.CallStateConnected:
    //   print('************************connected************************');
    //   this.setState(() {
    //     _inCalling = true;
    //   });
    //   break;
    // case SignalingState.CallStateRinging:
    //   print('************************Ringing************************');
    //   break;
    // case SignalingState.ConnectionClosed:
    // case SignalingState.ConnectionError:
    // case SignalingState.ConnectionOpen:
    //   break;
    // }
    // };
  }

  void dispose() {
    _socket.dispose();
  }
}
