import 'package:shared_preferences/shared_preferences.dart';

import '../networking/api.dart';
import '../networking/customException.dart';
import '../models/patient.dart';

class AuthenticationRepository {
  Api _api = Api();

  Future<void> login(String mobileNo, String password) async {
    final data = await _api.post('/patient/post/login', false,
        {'mobile_no': mobileNo, 'password': password});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('jwt', data['token']);
  }

  Future<String> checkPreviousLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jwt = sharedPreferences.getString('jwt');
    if (jwt == null) {
      throw CustomException('first');
    }
    final data =
        await _api.post('/patient/verify/token', false, {'token': jwt});
    return data['mobile_no'];
  }

  Future<void> register(Patient patient) async {
    await _api.post('/patient/post/register', false, patient);
  }

  Future<void> logOut() async {
    await _api.post('/patient/post/logout', true, {});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('jwt');
  }
}
