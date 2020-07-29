import 'package:flutter/material.dart';

import '../utils.dart';

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
            _Tile('Home', Icons.home, selected == Selected.home),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile('Appointments Today', Icons.schedule,
                selected == Selected.appointmentsToday),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
                'Find Doctors', Icons.search, selected == Selected.findDoctors),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile('Appointments', Icons.insert_invitation,
                selected == Selected.appointments),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile('Prescriptions', Icons.content_paste,
                selected == Selected.prescriptions),
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

  _Tile(this.title, this.icon, this.selected);

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
        // onTap: () {
        //   Navigator.of(context).pushNamed(homeScreen);
        // },
      ),
    );
  }
}
