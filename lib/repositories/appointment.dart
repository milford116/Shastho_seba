import 'package:shastho_sheba/models/schedule.dart';

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
    final data = await _api.get('/patient/get/future/appointment', true);
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }

  Future<List<Appointment>> todayAppointments() async {
    final data = await _api.get('/patient/get/today/appointment', true);
    // print(data);
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }

  // Future<List<Schedule>> allappointment() async {
  //   final data = await _api.get('/doctor/get/schedulenew', true);
  //   // print('frnt');
  //   //print(data['schedules']);
  //   return data['schedules']
  //       .map<Schedule>((json) => Schedule.fromJson(json))
  //       .toList();
  // }

  Future<List<Appointment>> getAppointments(String doctorMobileNo) async {
    final data = await _api.post('/patient/get/appointments', true, {
      'doctor_mobile_no': doctorMobileNo,
    });
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }

  Future<int> createAppointment(
      String scheduleId, String mobileNo, DateTime dateTime) async {
    final data = await _api.post('/patient/post/appointment', true, {
      'schedule_id': scheduleId,
      'doc_mobile_no': mobileNo,
      'appointment_date_time': dateTime.toString(),
    });
    return data['serial_no'];
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _api.post('/patient/cancel/appointment', true, {
      'id': appointmentId,
    });
  }
}
