import 'dart:async';
import 'package:Shastho_Sheba/models/schedule.dart';
import 'package:Shastho_Sheba/repositories/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';

import '../networking/response.dart';

class ScheduleTodayBloc extends ChangeNotifier implements BaseBloc {
  ScheduleRepository _scheduleRepository;
  StreamController _scheduleController;

  StreamSink<Response<List<Schedule>>> get sink =>
      _scheduleController.sink;

  Stream<Response<List<Schedule>>> get stream =>
      _scheduleController.stream;


  SchedulesTodayBloc() {
    _scheduleRepository = ScheduleRepository();

    _scheduleController = StreamController<Response<List<Schedule>>>();
    //fetchTodayschedule();
  }

  // void fetchTodayschedule() async {
  //   sink.add(Response.loading('Fetching schedules'));
  //   try {
  //     final list = await _scheduleRepository.getScheduletoday();
  //    // print('in sink');
  //     //print(list);
  //     sink.add(Response.completed(list));
  //   } catch (e) {
  //     sink.add(Response.error(e.toString()));
  //   }
  // }

  @override
  void dispose() {
    _scheduleController?.close();
    super.dispose();
  }
}
