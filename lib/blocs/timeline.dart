import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../networking/response.dart';
import '../repositories/appointment.dart';

class TimelineBloc extends ChangeNotifier implements BaseBloc {
  AppointmentsRepository _appointmentsRepository;
  StreamController _timelineController;
  Appointment _appointment;
  List<Appointment> _list;

  StreamSink<Response<List<Appointment>>> get sink => _timelineController.sink;

  Stream<Response<List<Appointment>>> get stream => _timelineController.stream;

  TimelineBloc(this._appointment) {
    _appointmentsRepository = AppointmentsRepository();
    _timelineController = StreamController<Response<List<Appointment>>>();
    fetchTimeline();
  }

  void fetchTimeline() async {
    sink.add(Response.loading('Fetching Timeline'));
    try {
      _list = await _appointmentsRepository
          .getAppointments(_appointment.doctor.mobileNo);
      sink.add(Response.completed(_list));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _appointmentsRepository.cancelAppointment(appointmentId);
  }

  void updateDue(double due, String appointmentId) {
    _list.firstWhere((element) => element.id == appointmentId).due = due;
    notifyListeners();
  }

  @override
  void dispose() {
    _timelineController?.close();
    super.dispose();
  }
}
