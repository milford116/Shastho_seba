import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/authentication.dart';

class LoginBloc implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _loginController;

  StreamSink<Response<String>> get sink => _loginController.sink;

  Stream<Response<String>> get stream => _loginController.stream;

  LoginBloc() {
    _authenticationRepository = AuthenticationRepository();
    _loginController = StreamController<Response<String>>();
    sink.add(Response.idle());
  }

  void login(String mobileNo, String password) async {
    sink.add(Response.loading("Logging In"));
    try {
      String jwt = await _authenticationRepository.login(mobileNo, password);
      sink.add(Response.completed(''));
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('jwt', jwt);
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _loginController?.close();
  }
}
