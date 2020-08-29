import 'dart:async';
import 'package:flutter/material.dart';

import '../routes.dart';
import '../utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacementNamed(loginScreen);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(splashbackgroundimage),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Welcome To',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              'ShasthoSheba',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
