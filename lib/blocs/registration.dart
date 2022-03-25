import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/authentication.dart';
import '../models/patient.dart';

class RegistrationBloc extends ChangeNotifier implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _registrationController;
  String _sex = 'Male';
  DateTime _selectedDate;
  final formKey = GlobalKey<FormState>();
  final dob = TextEditingController();
  final pass = TextEditingController();
  final name = TextEditingController();
  final mobileNo = TextEditingController();
  Validator validator;

  StreamSink<Response<String>> get sink => _registrationController.sink;

  Stream<Response<String>> get stream => _registrationController.stream;

  String get sex => _sex;

  DateTime get selectedDate => _selectedDate;

  set sex(String value) {
    _sex = value;
    notifyListeners();
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    dob.text = DateFormat.yMMMMd('en_US').format(selectedDate);
    notifyListeners();
  }

  RegistrationBloc() {
    _authenticationRepository = AuthenticationRepository();
    _registrationController = StreamController<Response<String>>();
    validator = Validator(pass);
    //validator = Validator();
  }

  void register() async {
    if (formKey.currentState.validate()) {
      Patient patient = Patient(
        name: name.text,
        mobileNo: mobileNo.text,
        dob: selectedDate,
        sex: sex,
        // password: pass.text,
      );
      sink.add(Response.loading('Please Wait'));
      try {
        await _authenticationRepository.register(patient);
        sink.add(Response.completed('Registered Successfully'));
      } catch (e) {
        sink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    _registrationController?.close();
    dob.dispose();
    // pass.dispose();
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

  // String mobileNoValidator(String value) {
  //   if (value.isEmpty) {
  //     return "Please enter your Mobile Number";
  //   }
  //   return null;
  // }

  String dobValidator(String value) {
    if (value.isEmpty) {
      return "Please enter your Date of Birth";
    }
    return null;
  }

  // String passwordValidator(String value) {
  //   if (value.isEmpty) {
  //     return "Please provide a password";
  //   }
  //   return null;
  // }

  // String confirmPasswordValidator(String value) {
  //   if (value != pass.text) {
  //     return 'Password does not match';
  //   }
  //   return null;
  // }
}
