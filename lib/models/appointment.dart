import 'schedule.dart';
import 'doctor.dart';
import 'patient.dart';

enum AppointmentStatus { NoPayment, NotVerified, Verified, Finished }

Map<int, AppointmentStatus> map = {
  0: AppointmentStatus.NoPayment,
  1: AppointmentStatus.NotVerified,
  2: AppointmentStatus.Verified,
  3: AppointmentStatus.Finished,
};

class Appointment {
  final String id;
  Schedule schedule;
  Doctor doctor;
  Patient patient;
  final DateTime dateTime;
  final AppointmentStatus status;
  final int serialNo;

  Appointment({
    this.id,
    this.doctor,
    this.patient,
    this.dateTime,
    this.schedule,
    this.status,
    this.serialNo,
  });

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        status = map[json['status']],
        serialNo = json['serial_no'],
        dateTime = DateTime.parse(json['appointment_date_time']) {
    if (!(json['schedule_id'] is String)) {
      schedule = Schedule.fromJson(json['schedule_id']);
    }
    if (!(json['doctorId'] is String)) {
      doctor = Doctor.fromJson(json['doctorId']);
    }
    if (!(json['patientId'] is String)) {
      patient = Patient.fromJson(json['patientId']);
    }
  }
}
