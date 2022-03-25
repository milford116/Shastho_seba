import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import '../blocs/registration.dart';
import '../networking/response.dart';
import '../widgets/loading.dart';

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
          title: Text('Patient Registration'),
        ),
        body: SafeArea(
          child: Center(
            child: ChangeNotifierProvider(
              create: (context) => RegistrationBloc(),
              child: Builder(
                builder: (context) {
                  RegistrationBloc registrationBloc =
                      Provider.of<RegistrationBloc>(context);
                  return StreamBuilder(
                    stream: registrationBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<String> data = snapshot.data;
                        switch (data.status) {
                          case Status.LOADING:
                            return Loading(data.message);
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
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(data.message),
                                  duration: Duration(seconds: 2),
                                ),
                              ),
                            );
                            break;
                        }
                      }
                      return _RegistrationForm();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RegistrationBloc registrationBloc = Provider.of<RegistrationBloc>(context);
    return ListView(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      children: <Widget>[
        Form(
          key: registrationBloc.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextFormField(
                controller: registrationBloc.name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                ),
                validator: registrationBloc.validator.nameValidator,
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
                            value: 'Male',
                            groupValue: registrationBloc.sex,
                            onChanged: (String value) {
                              registrationBloc.sex = value;
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
                            value: 'Female',
                            groupValue: registrationBloc.sex,
                            onChanged: (String value) {
                              registrationBloc.sex = value;
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
                controller: registrationBloc.mobileNo,
                decoration: InputDecoration(
                  labelText: 'Mobile No',
                  icon: Icon(Icons.phone_android),
                ),
                // validator: registrationBloc.validator.mobileNoValidator,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: registrationBloc.dob,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.date_range),
                  icon: Opacity(
                    child: Icon(Icons.phone_android),
                    opacity: 0.0,
                  ),
                ),
                validator: registrationBloc.validator.dobValidator,
                onTap: () async {
                  DateTime selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(
                      Duration(
                        days: 36500,
                      ),
                    ),
                    initialDate: registrationBloc.selectedDate == null
                        ? DateTime.now()
                        : registrationBloc.selectedDate,
                    initialDatePickerMode: DatePickerMode.year,
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    registrationBloc.selectedDate = selectedDate;
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              // TextFormField(
              //   controller: registrationBloc.pass,
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     labelText: 'Password',
              //     icon: Icon(Icons.lock),
              //   ),
              //   validator: registrationBloc.validator.passwordValidator,
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // TextFormField(
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     labelText: 'Confirm Password',
              //     icon: Icon(Icons.lock),
              //   ),
              //   validator: registrationBloc.validator.confirmPasswordValidator,
              // ),
              // SizedBox(
              //   height: 50.0,
              // ),
              FlatButton(
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                color: blue,
                onPressed: registrationBloc.register,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
