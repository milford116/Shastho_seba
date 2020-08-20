import '../networking/api.dart';
import '../models/timeline.dart';
import '../models/appointment.dart';

class TimelineRepository {
  Api _api = Api();

  Future<List<Timeline>> getTimelines(Appointment appointment) async {
    final data = await _api.post('/patient/get/timeline', true,
        {'doctor_mobile_no': appointment.doctor.mobileNo});

    return data['timeline']
        .map<Timeline>((json) => Timeline.fromJson(json))
        .toList();
  }
}
