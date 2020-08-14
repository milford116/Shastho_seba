import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../networking/response.dart';
import '../repositories/appointments.dart';

class PreviousAppointmentsBloc extends ChangeNotifier implements BaseBloc {
  AppointmentsRepository _appointmentsRepository;
  StreamController _appointmentsController;

  StreamSink<Response<List<Appointment>>> get sink =>
      _appointmentsController.sink;

  Stream<Response<List<Appointment>>> get stream =>
      _appointmentsController.stream;

  PreviousAppointmentsBloc() {
    _appointmentsRepository = AppointmentsRepository();
    _appointmentsController = StreamController<Response<List<Appointment>>>();
    fetchPreviousAppointments();
  }

  void fetchPreviousAppointments() async {
    sink.add(Response.loading('Fetching Appointments'));
    try {
      final list = await _appointmentsRepository.previousAppointments();
      sink.add(Response.completed(list));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _appointmentsController?.close();
    super.dispose();
  }
}
