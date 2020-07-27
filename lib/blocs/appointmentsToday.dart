import 'dart:async';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/appointmentsToday.dart';
import '../models/appointment.dart';

class LoginBloc implements BaseBloc{
  AppointmentsTodayRepository _appointmentsRepository;
  StreamController _appointmentsController;

  StreamSink<Response<List<Appointment>>> get appointmentsSink =>
      _appointmentsController.sink;

  Stream<Response<List<Appointment>>> get appointmentsStream =>
      _appointmentsController.stream;

  LoginBloc() {
    _appointmentsRepository = AppointmentsTodayRepository();
    _appointmentsController = StreamController<Response<List<Appointment>>>();
  }

  void fetchAppointmentsToday() async {
    appointmentsSink.add(Response.loading("Loading Your Today's Appointments"));
    try {
      List<Appointment> appointments =
          await _appointmentsRepository.fetchAppointmentsToday();
      appointmentsSink.add(Response.completed(appointments));
    } catch (e) {
      appointmentsSink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _appointmentsController?.close();
  }
}
