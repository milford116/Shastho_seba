import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../networking/response.dart';
import '../repositories/appointment.dart';

class PreviousAppointmentsBloc extends ChangeNotifier implements BaseBloc {
  AppointmentsRepository _appointmentsRepository;
  StreamController _appointmentsController;
  StreamController<String> streamController = StreamController();

  List<Appointment> appointmentList;

  StreamSink<Response<List<Appointment>>> get sink =>
      _appointmentsController.sink;

  Stream<Response<List<Appointment>>> get stream =>
      _appointmentsController.stream;

  PreviousAppointmentsBloc() {
    _appointmentsRepository = AppointmentsRepository();
    _appointmentsController = StreamController<Response<List<Appointment>>>();

    streamController.stream
        .debounce(Duration(milliseconds: 400))
        .listen((value) {
      fetchPreviousAppointmentsWithFilter(value);
    });

    fetchPreviousAppointments();
  }

  void fetchPreviousAppointments() async {
    sink.add(Response.loading('Fetching Appointments'));
    try {
      appointmentList = await _appointmentsRepository.previousAppointments();
      sink.add(Response.completed(appointmentList));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  void fetchPreviousAppointmentsWithFilter(String value) async {
    if (value == '') {
      sink.add(Response.completed(appointmentList));
      return;
    }

    List<Appointment> filterList = List<Appointment>();

    appointmentList.forEach((appointment) {
      if (appointment.doctorName.toLowerCase().contains(value.toLowerCase()))
        filterList.add(appointment);
    });

    sink.add(Response.completed(filterList));
  }

  @override
  void dispose() {
    _appointmentsController?.close();
    streamController?.close();
    super.dispose();
  }
}
