import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes.dart';
import '../utils.dart';
import '../blocs/intermediaryRegBloc.dart';
import '../networking/response.dart';
import '../widgets/loading.dart';

class Patient_Nav extends StatelessWidget {
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
            title: Text('Navigation'),
          ),
           body: SafeArea(
          child: Center(
            child:FlatButton(
                    child: Text(
                      'Patient-Register-login',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: blue,
                    onPressed: () {
                      Navigator.pushNamed(context, loginScreen);
                    },
                  ), 
          ))
        ));
  }
}
