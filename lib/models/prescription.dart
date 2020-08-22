import 'package:Shastho_Sheba/models/medicine.dart';

class Prescription {
  final String appointmentId;
  final String prescriptionImg;
  final String patientName;
  final int patientAge;
  final String patientSex;
  final List<String> symptoms;
  final List<String> tests;
  final List<Medicine> medicine;

  Prescription({
    this.appointmentId,
    this.prescriptionImg,
    this.patientName,
    this.patientAge,
    this.patientSex,
    this.medicine,
    this.symptoms,
    this.tests,
  });

  Prescription.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointment_id'],
        prescriptionImg = json['prescription_img'],
        patientName = json['patient_name'],
        patientAge = json['patient_age'],
        patientSex = json['patient_sex'],
        symptoms = json['symptoms'].cast<String>(),
        tests = json['tests'].cast<String>(),
        medicine = json['medicine'] != null
            ? json['medicine']
                .map<Medicine>((json) => Medicine.fromJson(json))
                .toList()
            : null;
}