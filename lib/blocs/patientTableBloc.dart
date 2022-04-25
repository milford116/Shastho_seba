import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
// import '../repositories/patient.dart';
import '../repositories/intermediary.dart';
import '../models/patient.dart';

class PatientTableBloc extends ChangeNotifier implements BaseBloc {
  IntermedRepository _patientRepository;
  StreamController _tokensController;

  StreamSink<Response<List<Patient>>> get sink => _tokensController.sink;

  Stream<Response<List<Patient>>> get stream => _tokensController.stream;

  PatientTableBloc() {
    _patientRepository = IntermedRepository();
    _tokensController = StreamController<Response<List<Patient>>>();
    getPatientTokens();
  }

  void getPatientTokens() async {
    sink.add(Response.loading('Fetching Tokens'));
    try {
      final data = await _patientRepository.getPatients();
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _tokensController?.close();
    super.dispose();
  }
}
