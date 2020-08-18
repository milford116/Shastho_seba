import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/schedule.dart';
import '../repositories/appointment.dart';
import '../models/schedule.dart';
import '../models/doctor.dart';

class DoctorProfileBloc extends ChangeNotifier implements BaseBloc {
  ScheduleRepository _scheduleRepository;
  AppointmentsRepository _appointmentsRepository;
  StreamController _scheduleController;
  List<Schedule> _schedules;
  Doctor _doctor;

  StreamSink<Response<Map<String, List<Schedule>>>> get sink =>
      _scheduleController.sink;

  Stream<Response<Map<String, List<Schedule>>>> get stream =>
      _scheduleController.stream;

  DoctorProfileBloc(this._doctor) {
    _scheduleRepository = ScheduleRepository();
    _appointmentsRepository = AppointmentsRepository();
    _scheduleController =
        StreamController<Response<Map<String, List<Schedule>>>>();
    getSchedule();
  }

  void getSchedule() async {
    sink.add(Response.loading('Fetching Schedule'));
    try {
      _schedules = await _scheduleRepository.getSchedule(_doctor.mobileNo);

      Map<String, List<Schedule>> newschedulelist =
          Map<String, List<Schedule>>();

      _schedules.forEach((element) {
        if (!newschedulelist.containsKey(element.day)) {
          newschedulelist[element.day] = List<Schedule>();
        }

        newschedulelist[element.day].add(element);
      });

      print(newschedulelist);
      sink.add(Response.completed(newschedulelist));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  bool toShow(int weekDay) {
    for (var index = 0; index < _schedules.length; index++) {
      if (_schedules[index].weekDay == weekDay) {
        return true;
      }
    }
    return false;
  }

  DateTime initialDate() {
    DateTime date = DateTime.now();
    while (!toShow(date.weekday)) {
      date = date.add(Duration(days: 1));
    }
    return date;
  }

  List<Schedule> schedules(int weekDay) {
    List<Schedule> schedules = [];
    _schedules.forEach((schedule) {
      if (schedule.weekDay == weekDay) {
        schedules.add(schedule);
      }
    });
    return schedules;
  }

  Future<int> createAppointment(String scheduleId, DateTime dateTime) async {
    return await _appointmentsRepository.createAppointment(
        scheduleId, _doctor.mobileNo, dateTime);
  }

  @override
  void dispose() {
    _scheduleController?.close();
    super.dispose();
  }
}
