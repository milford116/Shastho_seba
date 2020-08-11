import '../networking/api.dart';
import '../models/appointment.dart';

class AppointmentsRepository {
  Api _api = Api();

  Future<List<Appointment>> previousAppointments() async {
    final data = await _api.get('/patient/get/past/appointment/', true);
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }

  Future<List<Appointment>> upcomingAppointments() async {
    final data = await _api.get('patient/get/future/appointment', true);
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }
}
