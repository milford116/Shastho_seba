import 'package:flutter/material.dart';

import '../utils.dart';
import '../routes.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home),
              Text(
                'Home',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.home),
        ),
        body: SafeArea(
          child: Center(
            child: GridView.count(
              // padding: EdgeInsets.symmetric(horizontal: 20.0),
              childAspectRatio: 1.5,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                _Tile(
                  title: 'Today Appointments',
                  icon: Icons.schedule,
                  route: appointmentsTodayScreen,
                ),
                _Tile(
                  title: 'Find Doctors',
                  icon: Icons.search,
                  route: findDoctorsScreen,
                ),
                _Tile(
                  title: 'Appointments',
                  icon: Icons.insert_invitation,
                  route: appointmentsScreen,
                ),
                _Tile(
                  title: 'Profile',
                  icon: Icons.person,
                  route: profileScreen,
                ),
                _Tile(
                  title: 'Feedback',
                  icon: Icons.feedback,
                  route: feedbackScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
