import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/doctor.dart';
import '../networking/response.dart';
import '../repositories/doctor.dart';
import 'package:stream_transform/stream_transform.dart';

class FindDoctorsBloc extends ChangeNotifier implements BaseBloc {
  DoctorsRepository _doctorsRepository;
  StreamController _doctorsController;
  StreamController<String> streamController = StreamController();

  List<Doctor> doctorList;

  StreamSink<Response<List<Doctor>>> get sink => _doctorsController.sink;

  Stream<Response<List<Doctor>>> get stream => _doctorsController.stream;

  FindDoctorsBloc(String speciality) {
    _doctorsRepository = DoctorsRepository();
    _doctorsController = StreamController<Response<List<Doctor>>>();
    streamController.stream
        .debounce(Duration(milliseconds: 400))
        .listen((value) {
      findDoctorsFilter(value);
    });
    findDoctors(speciality);
  }

  void findDoctors(String speciality) async {
    sink.add(Response.loading('Fetching Doctors'));
    try {
      doctorList = await _doctorsRepository.doctorsList(60, 0, speciality);
      sink.add(Response.completed(doctorList));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  void findDoctorsFilter(String value) async {
    if (value == '') {
      sink.add(Response.completed(doctorList));
      return;
    }

    List<Doctor> filterList = List<Doctor>();

    doctorList.forEach((doctor) {
      if (doctor.name.toLowerCase().contains(value.toLowerCase()))
        filterList.add(doctor);
    });

    sink.add(Response.completed(filterList));
  }

  @override
  void dispose() {
    _doctorsController?.close();
    streamController?.close();
    super.dispose();
  }
}
