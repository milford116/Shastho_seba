import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/patient.dart';
import '../models/patient.dart';

class ProfileBloc extends ChangeNotifier implements BaseBloc {
  PatientRepository _patientRepository;
  StreamController _profileController;

  StreamSink<Response<Patient>> get sink => _profileController.sink;

  Stream<Response<Patient>> get stream => _profileController.stream;

  ProfileBloc() {
    _patientRepository = PatientRepository();
    _profileController = StreamController<Response<Patient>>();
    getPatientDetails();
  }

  void getPatientDetails() async {
    sink.add(Response.loading('Fetching Details'));
    try {
      final data = await _patientRepository.getDetails();
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> uploadProfilePic() async {
    var selected = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(selected.path);
    sink.add(Response.loading('Uploading Image'));
    try {
      final data = await _patientRepository.uploadProfilePic(image);
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _profileController?.close();
    super.dispose();
  }
}
