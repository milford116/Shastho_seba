class Timeline {
  final String appointmentId;
  String transactionId;
  DateTime appointmentDate;
  DateTime appointmentCreatedAt;
  DateTime transactionCreatedAt;
  DateTime prescriptionCreatedAt;
  bool hasPrescription = false;

  Timeline({
    this.appointmentId,
    this.transactionId,
    this.appointmentDate,
    this.appointmentCreatedAt,
    this.transactionCreatedAt,
    this.prescriptionCreatedAt,
    this.hasPrescription,
  });

  Timeline.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointment_id'],
        transactionId = json['transaction_id'],
        appointmentDate = json['appointment_date'] != null
            ? DateTime.parse(json['appointment_date'])
            : DateTime.now(),
        appointmentCreatedAt = json['appointment_createdAt'] != null
            ? DateTime.parse(json['appointment_createdAt'])
            : DateTime.now(),
        transactionCreatedAt = json['transaction_createdAt'] != null
            ? DateTime.parse(json['transaction_createdAt'])
            : DateTime.now(),
        prescriptionCreatedAt = json['prescription_createdAt'] != null
            ? DateTime.parse(json['prescription_createdAt'])
            : DateTime.now() {
    if (json['prescription_createdAt'] != null) {
      hasPrescription = true;
    }
  }
}
