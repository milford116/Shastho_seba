import 'package:shastho_sheba/models/Schedoctor.dart';
import 'package:shastho_sheba/models/doctor.dart';

import '../networking/api.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  Api _api = Api();

  Future<List<Schedule>> getSchedule(String mobileno) async {
    final data =
        await _api.post('/patient/get/schedule', true, {'mobile_no': mobileno});

    return data['schedule']
        .map<Schedule>((json) => Schedule.fromJson(json))
        .toList();
  }

  Future<List<Schedule>> getScheduletoday() async {
    final data = await _api.get('/doctor/get/schedulenew', true);
    //print('here');

    // list.add( data['doctor']
    //     .map<Schedoctor>((json) => Schedoctor.fromJson(json))
    //     .toList());
    var list = data['schedules']
        .map<Schedule>((json) => Schedule.fromJson(json))
        .toList();
   

    return list;
  }
   Future<List<Doctor>> getdoctor() async {
    final data = await _api.get('/doctor/get/name', true);
    print('here');

    
    var list = data['doctor']
        .map<Doctor>((json) => Doctor.fromJson(json))
        .toList();
   

    return list;
  }
}
