import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/authentication.dart';
import '../models/intermediary.dart';

class InterRegistrationBloc extends ChangeNotifier implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _registrationController;
  final age = TextEditingController();
  String _sex = 'Male';
  final formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final name = TextEditingController();
  final mobileNo = TextEditingController();
  String _occupation_type = 'Orphanage-administrator';
  final location = TextEditingController();
  Validator validator;

  StreamSink<Response<String>> get sink => _registrationController.sink;

  Stream<Response<String>> get stream => _registrationController.stream;

  String get sex => _sex;
  String get occupation_type => _occupation_type;

  set sex(String value) {
    _sex = value;
    notifyListeners();
  }

  set occupation_type(String value) {
    _occupation_type = value;
    notifyListeners();
  }

  InterRegistrationBloc() {
    _authenticationRepository = AuthenticationRepository();
    _registrationController = StreamController<Response<String>>();
    validator = Validator(pass);
  }

  void register() async {
    if (formKey.currentState.validate()) {
      Intermediary intermediary = Intermediary(
        name: name.text,
        mobileNo: mobileNo.text,
        age: int.parse(age.text),
        sex: sex,
        occupation_type: occupation_type,
        location: location.text,
        password: pass.text,
      );
      sink.add(Response.loading('Please Wait'));
      try {
        await _authenticationRepository.interregister(intermediary);
        sink.add(Response.completed('Registered Successfully'));
      } catch (e) {
        sink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    _registrationController?.close();
    age.dispose();
    location.dispose();
    pass.dispose();
    name.dispose();
    mobileNo.dispose();
    super.dispose();
  }
}

class Validator {
  TextEditingController pass;

  Validator(this.pass);

  String nameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String mobileNoValidator(String value) {
    if (value.isEmpty) {
      return "Please enter your Mobile Number";
    }
    return null;
  }

  String ageValidator(String value) {
    
    if (int.parse(value).isNaN || int.parse(value).isInfinite || 
    int.parse(value).isNegative) {
      return "Please enter your age";
    }
    return null;
  }
  String locationValidator(String value) {
    if (value.isEmpty) {
      return "Please enter your location";
    }
    return null;
  }
  String passwordValidator(String value) {
    if (value.isEmpty) {
      return "Please provide a password";
    }
    return null;
  }

  String confirmPasswordValidator(String value) {
    if (value != pass.text) {
      return 'Password does not match';
    }
    return null;
  }
}
