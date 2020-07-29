import 'package:flutter/material.dart';

import '../utils.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/patient_background_low_opacity.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Text('Home'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.home),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: <Widget>[
                    _Tile("Appointments Today", Icons.schedule),
                    _Tile("Find Doctors", Icons.search),
                    _Tile("Appointments", Icons.insert_invitation),
                    _Tile("Prescriptions", Icons.content_paste),
                  ],
                ),
              ),
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

  _Tile(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {},
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
