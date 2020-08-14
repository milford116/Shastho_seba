import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/doctor.dart';
import '../networking/response.dart';
import '../repositories/findDoctors.dart';

class FindDoctorsBloc extends ChangeNotifier implements BaseBloc {
  FindDoctorsRepository _findDoctorsRepository;
  StreamController _doctorsController;

  StreamSink<Response<List<Doctor>>> get sink => _doctorsController.sink;

  Stream<Response<List<Doctor>>> get stream => _doctorsController.stream;

  FindDoctorsBloc(String speciality) {
    _findDoctorsRepository = FindDoctorsRepository();
    _doctorsController = StreamController<Response<List<Doctor>>>();
    findDoctors(speciality);
  }

  void findDoctors(String speciality) async {
    sink.add(Response.loading('Fetching Doctors'));
    try {
      final list = await _findDoctorsRepository.findDoctors(60, 0, speciality);
      print(list);
      sink.add(Response.completed(list));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _doctorsController?.close();
    super.dispose();
  }
}
