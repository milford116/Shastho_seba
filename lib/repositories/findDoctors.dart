import '../networking/api.dart';
import '../models/doctor.dart';

class FindDoctorsRepository {
  Api _api = Api();

  Future<List<Doctor>> findDoctors(int lim, int p, String speciality) async {
    final data = await _api.post('/doctor/search', true,
        {'limit': lim, 'page': p, 'specialization': speciality});

    return data['doctors']
        .map<Doctor>((json) => Doctor.fromJson(json))
        .toList();
  }
}
