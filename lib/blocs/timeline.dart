import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../models/timeline.dart';
import '../networking/response.dart';
import '../repositories/timeline.dart';
import '../repositories/appointment.dart';

class TimelineBloc extends ChangeNotifier implements BaseBloc {
  TimelineRepository _timelineRepository;
  AppointmentsRepository _appointmentsRepository;
  StreamController _timelineController;
  Appointment _appointment;

  StreamSink<Response<List<Timeline>>> get sink => _timelineController.sink;

  Stream<Response<List<Timeline>>> get stream => _timelineController.stream;

  TimelineBloc(this._appointment) {
    _timelineRepository = TimelineRepository();
    _appointmentsRepository = AppointmentsRepository();
    _timelineController = StreamController<Response<List<Timeline>>>();
    fetchTimeline();
  }

  void fetchTimeline() async {
    sink.add(Response.loading('Fetching Timeline'));
    try {
      final list = await _timelineRepository.getTimelines(_appointment);
      sink.add(Response.completed(list));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _appointmentsRepository.cancelAppointment(appointmentId);
  }

  @override
  void dispose() {
    _timelineController?.close();
    super.dispose();
  }
}
