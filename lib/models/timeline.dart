class Timeline {
  final String appointmentId;
  double due;
  DateTime appointmentDate;
  DateTime appointmentCreatedAt;
  DateTime transactionCreatedAt;
  DateTime prescriptionCreatedAt;
  bool hasPrescription = false;
  bool hasTransaction = false;

  Timeline({
    this.appointmentId,
    this.due,
    this.appointmentDate,
    this.appointmentCreatedAt,
    this.transactionCreatedAt,
    this.prescriptionCreatedAt,
    this.hasPrescription,
    this.hasTransaction,
  });

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value + .0;
    }
    return value;
  }

  Timeline.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointment_id'],
        due = _parseDouble(json['due']),
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
    if (json['transaction_createdAt'] != null) {
      hasTransaction = true;
    }
  }
}
