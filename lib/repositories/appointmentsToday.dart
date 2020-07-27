import '../networking/api.dart';
import '../models/appointment.dart';

class AppointmentsTodayRepository {
  Api _api = Api();

  Future<List<Appointment>> fetchAppointmentsToday() async {
    final data = await _api.get('/patient/get/today/appointment/', true);
    return data.map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();
  }
}
