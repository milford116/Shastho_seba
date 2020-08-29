import 'dart:io';
import '../networking/api.dart';
import '../models/patient.dart';

class PatientRepository {
  Api _api = Api();

  Future<Patient> getDetails() async {
    final data = await _api.get('/patient/get/details', true);
    return Patient.fromJson(data['patient']);
  }

  Future<Patient> uploadProfilePic(File image) async {
    final data =
        await _api.uploadImage('/patient/upload/profile_picture', image);
    return Patient.fromJson(data['patient']);
  }

  Future<void> logOut() async {
    await _api.post('/patient/post/logout', true, {});
  }
}
