import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils.dart';
import '../blocs/registration.dart';
import '../models/patient.dart';
import '../networking/response.dart';

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Text('Registration'),
        ),
        body: SafeArea(
          child: Center(
            child: _RegistrationForm(),
          ),
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<_RegistrationForm> {
  String _sex = 'male';
  DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final _dob = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  final _mobileNo = TextEditingController();
  final RegistrationBloc _registrationBloc = RegistrationBloc();

  @override
  void dispose() {
    _dob.dispose();
    _pass.dispose();
    _name.dispose();
    _mobileNo.dispose();
    _registrationBloc.dispose();
    super.dispose();
  }

  void _register() {
    Patient patient = Patient(
      name: _name.text,
      mobileNo: _mobileNo.text,
      dob: _selectedDate,
      sex: _sex,
      password: _pass.text,
    );
    _registrationBloc.register(patient);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _registrationBloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Response<String> data = snapshot.data;
          switch (data.status) {
            case Status.IDLE:
              return Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          TextFormField(
                            controller: _name,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  'Gender:',
                                  style: M,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 'male',
                                        groupValue: _sex,
                                        onChanged: (String value) {
                                          setState(() {
                                            _sex = value;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Male',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 'female',
                                        groupValue: _sex,
                                        onChanged: (String value) {
                                          setState(() {
                                            _sex = value;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Female',
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          TextFormField(
                            controller: _mobileNo,
                            decoration: InputDecoration(
                              labelText: 'Mobile No',
                              icon: Icon(Icons.phone_android),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your Mobile Number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _dob,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              suffixIcon: Icon(Icons.date_range),
                              icon: Opacity(
                                child: Icon(Icons.phone_android),
                                opacity: 0.0,
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your Date of Birth";
                              }
                              return null;
                            },
                            onTap: () async {
                              DateTime selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now().subtract(
                                  Duration(
                                    days: 36500,
                                  ),
                                ),
                                initialDate: _selectedDate == null
                                    ? DateTime.now()
                                    : _selectedDate,
                                initialDatePickerMode: DatePickerMode.year,
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                _selectedDate = selectedDate;
                                setState(() => _dob.text =
                                    DateFormat.yMMMMd('en_US')
                                        .format(selectedDate));
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please provide a password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              icon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value != _pass.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          FlatButton(
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: blue,
                            onPressed: _register,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              break;
            case Status.LOADING:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SpinKitFadingCube(
                    color: blue,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    data.message,
                    style: M,
                  ),
                ],
              );
              break;
            case Status.COMPLETED:
              Future.delayed(
                Duration(
                  seconds: 2,
                ),
                () => Navigator.pop(context),
              );
              return Text(
                data.data,
                style: M,
              );
              break;
            case Status.ERROR:
              Future.delayed(
                Duration(
                  seconds: 2,
                ),
                () => _registrationBloc.sink.add(Response.idle()),
              );
              return Text(
                data.data,
                style: M.copyWith(color: red),
              );
              break;
          }
        }
        return Container();
      },
    );
  }
}
