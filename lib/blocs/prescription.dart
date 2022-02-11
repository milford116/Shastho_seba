import 'dart:async';
import 'package:shastho_sheba/models/prescription.dart';
import 'package:shastho_sheba/repositories/prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/prescription.dart';
import '../networking/response.dart';

class PrescriptionBloc extends ChangeNotifier implements BaseBloc {
  PrescriptionRepository _prescriptionRepository;
  StreamController _prescriptionController;

  StreamSink<Response<Prescription>> get sink => _prescriptionController.sink;

  Stream<Response<Prescription>> get stream => _prescriptionController.stream;

  PrescriptionBloc(String appointmentId) {
    _prescriptionRepository = PrescriptionRepository();
    _prescriptionController = StreamController<Response<Prescription>>();
    getPrescription(appointmentId);
  }

  void getPrescription(String appointmentId) async {
    sink.add(Response.loading('Fetching Prescription'));
    try {
      final prescription =
          await _prescriptionRepository.getPrescription(appointmentId);
      sink.add(Response.completed(prescription));
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
