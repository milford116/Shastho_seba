// import 'package:flutter_webrtc/rtc_ice_candidate.dart';
// import 'package:flutter_webrtc/rtc_peerconnection.dart';
// import 'package:flutter_webrtc/rtc_peerconnection_factory.dart';
// import 'package:flutter_webrtc/media_stream.dart';
// import 'package:flutter_webrtc/get_user_media.dart';
// import 'package:flutter_webrtc/rtc_session_description.dart';

import 'dart:convert';
import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../utils/device_info.dart'
if (dart.library.js) '../../utils/device_info_web.dart';

import '../../utils/websocket.dart'
if (dart.library.js) '../../utils/websocket_web.dart';
import '../../utils/turn.dart' if (dart.library.js) '../../utils/turn_web.dart';

enum SignalingState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateCancel,
  CallStateConnected,
  CallStateEnd,
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

typedef void StreamStateCallback(MediaStream stream);
typedef void SignalingStateCallback(SignalingState state, [String from]);
typedef void SendMessageCallback(dynamic data);
typedef void CallReceiveCallback();
typedef void CallEndCallback();

class Signaling {
  SignalingStateCallback onStateChange;
  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  SendMessageCallback onSendMessage;
  CallReceiveCallback onCallReceive;
  CallEndCallback onCallEnd;

  Map<String, dynamic> _iceServers = {
    'iceServers': [
       // {'url': 'stun:124.64.206.224:8800'},
       // {'url':'turn:numb.viagenie.ca',
       //  'username':'elizaan199834@gmail.com',
       //   'credential':'fluttercd8'},
      {'url':'turn:turn.shasthosheba.live:3478',
        'username':'shastho_sheba',
        'credential':'shastho_sheba12'},

      // {'url': 'stun:stun.l.google.com:19302'},
      // {
      //   'url': 'turn:numb.viagenie.ca',
      //   'username': 'haidertameem@gmail.com',
      //   'credential': '01737849382t',
      // },
      // {
      //   'url': 'turn:52.221.24.60:3478',
      //   'username': 'server',
      //   'credential': 'secret',
      // },
      /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
       */
    ]
  };

  final Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': {
      'width': {
        'min': 640,
        'ideal': 1920,
      },
      'height': {
        'min': 400,
        'ideal': 1080,
      },
      'aspectRatio': {
        'ideal': 1.7777777778,
      },
      'mandatory': {
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  String _chamberId;
  dynamic _description;
  // Map<String, dynamic> _description;
  Map<String, RTCPeerConnection> _peerConnections =
      Map<String, RTCPeerConnection>();
  List<RTCIceCandidate> _remoteCandidates = [];
  List<MediaStream> _remoteStreams;
  MediaStream _localStream;

  void call(String chamberId) {
    if (onStateChange != null) {
      onStateChange(SignalingState.CallStateNew);
    }

    _createPeerConnection(chamberId).then((pc) {
      _peerConnections[chamberId] = pc;
      _createOffer(chamberId, pc);
    });
  }

  void receiveCall() async {
    var pc = await _createPeerConnection(_chamberId);
    _peerConnections[_chamberId] = pc;
    await pc.setRemoteDescription(
        new RTCSessionDescription(_description['sdp'], _description['type']));
    await _createAnswer(_chamberId, pc);
    if (onStateChange != null) {
      onStateChange(SignalingState.CallStateConnected);
    }
    if (this._remoteCandidates.length > 0) {
      _remoteCandidates.forEach((candidate) async {
        await pc.addCandidate(candidate);
      });
      _remoteCandidates.clear();
    }
  }

  void cancelCall() {
    onSendMessage({
      'chamberId': _chamberId,
      'type': 'cancel',
    });
  }

  void mute(bool mute) {


    _localStream
        .getAudioTracks()
        .forEach((element) => element.enabled = !element.enabled);

  }

  // void muteMic() {
  //   if (_localStream != null) {
  //     bool enabled = _localStream!.getAudioTracks()[0].enabled;
  //     _localStream!.getAudioTracks()[0].enabled = !enabled;
  //   }
  // }

  void toggleVideo(bool toggle) {
    _localStream
        .getVideoTracks()
        .forEach((element) => element.enabled = toggle);
  }

  void endCall(String chamberId) {
    _close(chamberId);
    onSendMessage({
      'chamberId': chamberId,
      'type': 'bye',
    });
  }

  void _close(String chamberId) {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }

    var pc = _peerConnections[chamberId];
    if (pc != null) {
      pc.close();
      _peerConnections.remove(chamberId);
    }

    if (onCallEnd != null) {
      onCallEnd();
    }
  }

  Future<RTCPeerConnection> _createPeerConnection(String chamberId) async {
    _localStream = await _createStream();
    RTCPeerConnection pc = await createPeerConnection(_iceServers, {});
    pc.addStream(_localStream);
    pc.onIceCandidate = (candidate) {
      onSendMessage({
        'chamberId': chamberId,
        'type': 'candidate',
        'candidate': {
          'sdpMLineIndex': candidate.sdpMLineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
      });
    };

    // pc.onIceCandidate = (candidate) async {
    //   if (candidate == null) {
    //     print('onIceCandidate: complete!');
    //     return;
    //   }
    //   // This delay is needed to allow enough time to try an ICE candidate
    //   // before skipping to the next one. 1 second is just an heuristic value
    //   // and should be thoroughly tested in your own environment.
    //   await Future.delayed(
    //       const Duration(seconds: 1),
    //           () => _send('candidate', {
    //         'to': peerId,
    //         'from': _selfId,
    //         'candidate': {
    //           'sdpMLineIndex': candidate.sdpMlineIndex,
    //           'sdpMid': candidate.sdpMid,
    //           'candidate': candidate.candidate,
    //         },
    //         'session_id': sessionId,
    //       }));
    // };

    pc.onIceConnectionState = (state) {};

    pc.onAddStream = (stream) {
      if (this.onAddRemoteStream != null) this.onAddRemoteStream(stream);

      //_remoteStreams.add(stream);
    };

    pc.onRemoveStream = (stream) {
      if (this.onRemoveRemoteStream != null) this.onRemoveRemoteStream(stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };
    return pc;
  }

  Future<MediaStream> _createStream() async {
    // final Map<String, dynamic> mediaConstraints = {
    //   'audio': true,
    //   'video': {
    //     'mandatory': {
    //       'minWidth':
    //           '640', // Provide your own width, height and frame rate here
    //       'minHeight': '480',
    //       'minFrameRate': '30',
    //     },
    //     'facingMode': 'user',
    //     'optional': [],
    //   }
    // };
    // MediaStream stream = userScreen
    //     ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
    //     : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    // onLocalStream?.call(stream);
    MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    if (this.onLocalStream != null) {
      this.onLocalStream(stream);
    }
    return stream;
  }

  void _createOffer(String chamberId, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createOffer({});
      pc.setLocalDescription(s);
      onSendMessage({
        'chamberId': chamberId,
        'type': 'offer',
        'description': {'sdp': s.sdp, 'type': s.type},
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _createAnswer(String chamberId, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createAnswer({});
      pc.setLocalDescription(s);
      onSendMessage({
        'chamberId': chamberId,
        'type': 'answer',
        'description': {'sdp': s.sdp, 'type': s.type},
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void onMessage(dynamic data) async {
    print('received');
    print(data);
    switch (data['type']) {
      case 'offer':
        _chamberId = data['chamberId'];
        _description = data['description'];

        // onSendMessage({
        //   'chamberId': chamberId,
        //   'type': 'ringing',
        // });

        if (onCallReceive != null) {
          onCallReceive();
        }

        break;
      // case 'ringing':
      //   if (onStateChange != null) {
      //     onStateChange(SignalingState.CallStateRinging);
      //   }
      //   break;
      // case 'cancel':
      //   if (onStateChange != null) {
      //     onStateChange(SignalingState.CallStateCancel);
      //   }
      //   break;
      case 'answer':
        var chamberId = data['chamberId'];
        var description = data['description'];

        var pc = _peerConnections[chamberId];
        if (pc != null) {
          await pc.setRemoteDescription(new RTCSessionDescription(
              description['sdp'], description['type']));
        }
        // onStateChange(SignalingState.CallStateConnected);
        break;
      case 'candidate':
        var chamberId = data['chamberId'];
        var candidateMap = data['candidate'];
        var pc = _peerConnections[chamberId];
        RTCIceCandidate candidate = new RTCIceCandidate(
            candidateMap['candidate'],
            candidateMap['sdpMid'],
            candidateMap['sdpMLineIndex']);
        if (pc != null) {
          await pc.addCandidate(candidate);
        } else {
          _remoteCandidates.add(candidate);
        }
        break;
      case 'bye':
        var chamberId = data['chamberId'];
        _close(chamberId);
        break;
    }
  }
}
