import 'package:shastho_sheba/models/doctor.dart';

class Schedule {
  final String id;
  final int weekDay;
  final DateTime start;
  final DateTime end;
  final double fee;
  final String doc_mobile_no;
  //Doctor doctor;
  static Map<int, String> _map = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  Schedule({this.id, this.weekDay, this.start, this.end, this.fee,this.doc_mobile_no});

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value + .0;
    }
    return value;
  }

  String get day => _map[weekDay];

  Schedule.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        weekDay = json['day'],
        start = json['time_start'] != null
            ? DateTime.parse(json['time_start'])
            : DateTime.now(),
        fee = _parseDouble(json['fee']),
        doc_mobile_no=json['doc_mobile_no'],

        //  doctor = Doctor.fromJson(json['doc_mobile_no']),

        end = json['time_end'] != null
            ? DateTime.parse(json['time_end'])
            : DateTime.now();
}
