import '../networking/api.dart';
import '../models/doctor.dart';
import 'package:intl/intl.dart';
class DoctorsRepository {
  Api _api = Api();

  Future<List<Doctor>> doctorsList(int lim, int p, String speciality) async {
    final data = await _api.post('/doctor/search', true,
        {'limit': lim, 'page': p, 'specialization': speciality});

    return data['doctors']
        .map<Doctor>((json) => Doctor.fromJson(json))
        .toList();
  }
  Future<List<Doctor>> doctorlist(int lim, int p, String mobile) async {
    final data = await _api.post('/doctor/search', true,
        {'limit': lim, 'page': p, 'mobile_no': mobile});

    return data['doctors']
        .map<Doctor>((json) => Doctor.fromJson(json))
        .toList();
  }
  void appointpush (String schedule_id,String mobile,DateTime date) async
  {
    final data= await _api.post('/patient/post/appointment', true,
    {'doc_mobile_no':mobile ,'schedule_id':schedule_id,'appointment_date_time':date});
    print('ye kam hoise');
  }
}
