import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/webrtc.dart';

import 'callState.dart';
import '../chamber/signaling.dart';
import '../baseBloc.dart';
import '../../networking/response.dart';
import '../../models/appointment.dart';

class VideoCallBloc extends ChangeNotifier implements BaseBloc {
  StreamController _videoCallController;
  Signaling _signaling;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  Appointment _appointment;

  StreamSink<Response<CallState>> get sink => _videoCallController.sink;

  Stream<Response<CallState>> get stream => _videoCallController.stream;

  VideoCallBloc(this._signaling, this._appointment) {
    _videoCallController = StreamController<Response<CallState>>();

    _signaling.onLocalStream = ((stream) {
      localRenderer.srcObject = stream;
    });

    _signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
    });

    _signaling.onRemoveRemoteStream = ((stream) {
      remoteRenderer.srcObject = null;
    });

    _signaling.onCallEnd =
        () => sink.add(Response.completed(CallState.EndCall));

    _initRenderders();
    sink.add(Response.completed(CallState.Ringing));
  }

  void _initRenderders() {
    localRenderer.initialize();
    remoteRenderer.initialize();
    remoteRenderer.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
  }

  void receiveCall() {
    _signaling.receiveCall();
    sink.add(Response.completed(CallState.Connected));
  }

  void endCall() {
    _signaling.endCall(_appointment.id);
    sink.add(Response.completed(CallState.EndCall));
  }

  @override
  void dispose() {
    _videoCallController?.close();
    remoteRenderer.dispose();
    localRenderer.dispose();
    super.dispose();
  }
}
