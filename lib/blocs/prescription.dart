import 'dart:async';
import 'package:Shastho_Sheba/models/prescription.dart';
import 'package:Shastho_Sheba/repositories/prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/prescription.dart';
import '../networking/response.dart';

class PrescriptionBloc extends ChangeNotifier implements BaseBloc {
  PrescriptionRepository _prescriptionRepository;
  StreamController _prescriptionController;

  StreamSink<Response<List<Prescription>>> get sink =>
      _prescriptionController.sink;

  Stream<Response<List<Prescription>>> get stream =>
      _prescriptionController.stream;

  PrescriptionBloc(String appointmentId) {
    _prescriptionRepository = PrescriptionRepository();
    _prescriptionController = StreamController<Response<List<Prescription>>>();
    getPrescription(appointmentId);
  }

  void getPrescription(String appointmentId) async {
    sink.add(Response.loading('Fetching Prescriptions'));
    try {
      final list = await _prescriptionRepository.getPrescription(appointmentId);
      sink.add(Response.completed(list));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _prescriptionController?.close();
    super.dispose();
  }
}
