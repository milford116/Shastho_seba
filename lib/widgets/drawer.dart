import 'package:flutter/material.dart';

import '../utils.dart';
import '../routes.dart';

enum Selected {
  home,
  appointmentsToday,
  findDoctors,
  appointments,
  prescriptions,
}

class MyDrawer extends StatelessWidget {
  final Selected selected;

  MyDrawer(this.selected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: lightBlue,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  'ShasthoSheba',
                  style: XL.copyWith(color: Colors.white),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Home',
              icon: Icons.home,
              selected: selected == Selected.home,
              route: homeScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Appointments Today',
              icon: Icons.schedule,
              selected: selected == Selected.appointmentsToday,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Find Doctors',
              icon: Icons.search,
              selected: selected == Selected.findDoctors,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Appointments',
              icon: Icons.insert_invitation,
              selected: selected == Selected.appointments,
              route: appointmentsScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Prescriptions',
              icon: Icons.content_paste,
              selected: selected == Selected.prescriptions,
              route: prescriptionsScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final String route;

  _Tile({this.title, this.icon, this.selected, this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? Colors.white : Colors.transparent,
      child: ListTile(
        title: Text(
          title,
          style: L.copyWith(
            color: selected ? blue : Colors.white,
          ),
        ),
        trailing: Icon(
          icon,
          color: selected ? blue : Colors.white,
          size: 30,
        ),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(route);
        },
      ),
    );
  }
}
