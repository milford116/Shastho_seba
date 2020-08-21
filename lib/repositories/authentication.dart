import '../networking/api.dart';
import '../models/patient.dart';

class AuthenticationRepository {
  Api _api = Api();

  Future<String> login(String mobileNo, String password) async {
    final data = await _api.post('/patient/post/login', false,
        {'mobile_no': mobileNo, 'password': password});
    final Patient patient = Patient.fromJson(data['patient']);
    return data['token'];
  }

  Future<void> register(Patient patient) async {
    await _api.post('/patient/post/register', false, patient);
  }
}
