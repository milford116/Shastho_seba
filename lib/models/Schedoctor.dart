import 'package:Shastho_Sheba/models/doctor.dart';

class Schedoctor {
  final String id;
  final int weekDay;
  final DateTime start;
  final DateTime end;
  final double fee;
  final String name;
  final String email;
  final String mobileNo;
  final String institution;
  final List<String> specialization;
  final String designation;
  final String registrationNo;
  final String referrer;
  final String aboutMe;
  final String image;

  static Map<int, String> _map = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  Schedoctor({this.id, this.weekDay, this.start, this.end, this.fee, this.name,
    this.email,
    this.mobileNo,
    this.institution,
    this.specialization,
    this.designation,
    this.registrationNo,
    this.referrer,
    this.aboutMe,
    this.image,});

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value + .0;
    }
    return value;
  }

  String get day => _map[weekDay];

  Schedoctor.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        weekDay = json['day'],
        start = json['time_start'] != null
            ? DateTime.parse(json['time_start'])
            : DateTime.now(),
        fee = _parseDouble(json['fee']),
        name=json['name'],
        mobileNo = json['mobile_no'],
        email = json['email'],
        designation = json['designation'],
        institution = json['institution'],
        specialization = json['specialization'].cast<String>(),
        referrer = json['referrer'],
        registrationNo = json['reg_number'],
        image = json['image'],
        aboutMe = json['about_me'],
        end = json['time_end'] != null
            ? DateTime.parse(json['time_end'])
            : DateTime.now();
        
}
