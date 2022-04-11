import 'package:shared_preferences/shared_preferences.dart';

import '../networking/api.dart';
import '../networking/customException.dart';
import '../models/patient.dart';
import '../models/intermediary.dart';

class AuthenticationRepository {
  Api _api = Api();

  Future<void> login(String patient_token) async {
    final data = await _api
        .post('/patient/post/login', true, {'patient_token': patient_token});
    print(data['token']);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('jwt', data['token']);
    print(data['token']);
  }

  Future<String> checkPreviousLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jwt = sharedPreferences.getString('jwt');
    if (jwt == null) {
      throw CustomException('first');
    }
    final data =
        await _api.post('/patient/verify/token', false, {'token': jwt});
    return data['patient_token'];
  }

  Future<void> register(Patient patient) async {
    await _api.post('/patient/post/register', true, patient);
  }

  Future<void> logOut() async {
    final data = await _api.post('/patient/post/logout', true, {});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('jwt');
    sharedPreferences.setString('jwt', data['token']);
  }

  // for intermediary part

  Future<void> interlogin(String mobileNo, String password) async {
    final data = await _api.post('/intermediary/post/login', false,
        {'mobile_no': mobileNo, 'password': password});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('jwt', data['token']);

  }

  Future<String> intercheckPreviousLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jwt = sharedPreferences.getString('jwt');
    if (jwt == null) {
      throw CustomException('first');
    }
    final data =
        await _api.post('/intermediary/verify/token', false, {'token': jwt});
    return data['mobile_no'];
  }

  Future<void> interregister(Intermediary intermediary) async {
    await _api.post('/intermediary/post/register', false, intermediary);
  }

  Future<void> interlogOut() async {
    await _api.post('/intermediary/post/logout', true, {});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('jwt');
  }
}
