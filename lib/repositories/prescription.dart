import '../networking/api.dart';
import '../models/prescription.dart';

class PrescriptionRepository {
  Api _api = Api();

  Future<List<Prescription>> getPrescription(String appointmentId) async {
    final data = await _api.post(
        '/patient/get/prescription', true, {'appointment_id': appointmentId});

    return data['prescription']
        .map<Prescription>((json) => Prescription.fromJson(json))
        .toList();
  }
}
