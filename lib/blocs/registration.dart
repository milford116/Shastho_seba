import 'dart:async';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/authentication.dart';
import '../models/patient.dart';

class RegistrationBloc implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _registrationController;

  StreamSink<Response<String>> get sink => _registrationController.sink;

  Stream<Response<String>> get stream => _registrationController.stream;

  RegistrationBloc() {
    _authenticationRepository = AuthenticationRepository();
    _registrationController = StreamController<Response<String>>();
    sink.add(Response.idle());
  }

  void register(Patient patient) async {
    sink.add(Response.loading('Please Wait'));
    try {
      await _authenticationRepository.register(patient);
      sink.add(Response.completed('Registered Successfully'));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _registrationController?.close();
  }
}
