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
    // print('here');
    // print(data);
    return data['schedules']
        .map<Schedule>((json) => Schedule.fromJson(json))
        .toList();
  }
}
