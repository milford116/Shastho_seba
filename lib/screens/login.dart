import 'package:flutter/material.dart';

import '../utils.dart';
import '../routes.dart';

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _LoginForm(),
            ),
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: SizedBox()),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Mobile No.',
              icon: Icon(Icons.phone_android),
            ),
          ),
          TextFormField(
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
                  Navigator.of(context).pushReplacementNamed(homeScreen);
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
                    Navigator.pushNamed(context, registrationScreen);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
