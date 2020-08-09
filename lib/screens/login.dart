import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils.dart';
import '../routes.dart';
import '../blocs/login.dart';
import '../networking/response.dart';

class LoginScreen extends StatelessWidget {
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
          title: Text('Login'),
        ),
        body: SafeArea(
          child: Center(
            child: _LoginForm(),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final formKey = GlobalKey<FormState>();
  final mobileNo = TextEditingController();
  final pass = TextEditingController();
  String errorMessage;
  final LoginBloc loginBloc = LoginBloc();

  @override
  void dispose() {
    mobileNo.dispose();
    pass.dispose();
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: loginBloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Response<String> data = snapshot.data;
          switch (data.status) {
            case Status.IDLE:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(child: SizedBox()),
                      TextFormField(
                        controller: mobileNo,
                        decoration: InputDecoration(
                          labelText: 'Mobile No.',
                          icon: Icon(Icons.phone_android),
                          errorText: errorMessage,
                        ),
                      ),
                      TextFormField(
                        controller: pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton.icon(
                            onPressed: () {
                              loginBloc.login(mobileNo.text, pass.text);
                            },
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            ),
                            color: blue,
                            label: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Don\'t have an account?'),
                            SizedBox(
                              width: 5,
                            ),
                            FlatButton(
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: blue,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, registrationScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                Duration(milliseconds: 10),
                () => Navigator.pushNamed(context, homeScreen),
              );
              break;
            case Status.ERROR:
              errorMessage = data.message;
              loginBloc.sink.add(Response.idle());
              break;
          }
        }
        return Container();
      },
    );
  }
}
