import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/getSchedule.dart';
import '../models/schedule.dart';

class GetScheduleBloc extends ChangeNotifier implements BaseBloc {
  GetScheduleRepository _getScheduleRepository;
  StreamController _scheduleController;

  StreamSink<Response<Map<String, List<Schedule>>>> get sink =>
      _scheduleController.sink;

  Stream<Response<Map<String, List<Schedule>>>> get stream =>
      _scheduleController.stream;

  GetScheduleBloc(String mobileno) {
    _getScheduleRepository = GetScheduleRepository();
    _scheduleController =
        StreamController<Response<Map<String, List<Schedule>>>>();
    getSchedule(mobileno);
  }

  void getSchedule(String mobileno) async {
    sink.add(Response.loading('Fetching Schedule'));
    try {
      List<Schedule> list = await _getScheduleRepository.getSchedule(mobileno);
      Map<String, List<Schedule>> newschedulelist =
          Map<String, List<Schedule>>();

      list.forEach((element) {
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

  @override
  void dispose() {
    _scheduleController?.close();
    super.dispose();
  }
}
