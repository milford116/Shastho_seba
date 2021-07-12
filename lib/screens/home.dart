import 'dart:async';
import 'package:flutter/material.dart';

import '../utils.dart';
import '../routes.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _backPressed = false;
  Timer _timer;
  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context).settings.arguments;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home),
              Text(
                'হোম',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.home),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (message != null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                );
              }
              return WillPopScope(
                onWillPop: () => _exitApp(context),
                child: Center(
                  child: GridView.count(
                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: <Widget>[
                      _Tile(
                        title: 'আজকের অ্যাপয়েণ্টমেন্ট',
                        icon: Icons.schedule,
                        route: appointmentsTodayScreen,
                      ),
                      _Tile(
                        title: 'ডাক্তার খুঁজুন',
                        icon: Icons.search,
                        route: findDoctorsScreen,
                      ),
                      _Tile(
                        title: 'অ্যাপয়েন্টমেন্ট',
                        icon: Icons.insert_invitation,
                        route: appointmentsScreen,
                      ),
                      _Tile(
                        title: 'প্রোফাইল',
                        icon: Icons.person,
                        route: profileScreen,
                      ),
                      _Tile(
                        title: 'নিজের মতামত',
                        icon: Icons.feedback,
                        route: feedbackScreen,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (_backPressed) {
      _timer.cancel();
      return true;
    }
    _backPressed = true;
    _timer = Timer(Duration(seconds: 2), () => _backPressed = false);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Press back again to exit'),
        duration: Duration(seconds: 2),
      ),
    );
    return false;
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  _Tile({this.title, this.icon, this.route});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 40,
            color: blue,
          ),
          Text(
            title,
            style: L.copyWith(color: blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
