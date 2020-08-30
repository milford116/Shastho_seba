import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/authentication.dart';

class LoginBloc extends ChangeNotifier implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _loginController;
  final formKey = GlobalKey<FormState>();
  final mobileNo = TextEditingController();
  final pass = TextEditingController();
  String errorMessage;

  StreamSink<Response<String>> get sink => _loginController.sink;

  Stream<Response<String>> get stream => _loginController.stream;

  LoginBloc() {
    _authenticationRepository = AuthenticationRepository();
    _loginController = StreamController<Response<String>>();
  }

  void login() async {
    sink.add(Response.loading("Logging In"));
    try {
      await _authenticationRepository.login(mobileNo.text, pass.text);
      sink.add(Response.completed(''));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _loginController?.close();
    mobileNo.dispose();
    pass.dispose();
    super.dispose();
  }
}
