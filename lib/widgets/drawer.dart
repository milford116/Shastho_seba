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
                  style: xl.copyWith(color: Colors.white),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            Container(
              color:
                  selected == Selected.home ? Colors.white : Colors.transparent,
              child: ListTile(
                title: Text(
                  'Home',
                  style: l.copyWith(
                    color: selected == Selected.home ? blue : Colors.white,
                  ),
                ),
                trailing: Icon(Icons.home,
                    color: selected == Selected.home ? blue : Colors.white,
                    size: 30),
                onTap: () {
                  Navigator.of(context).pushNamed(homeScreen);
                },
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            Container(
              color: selected == Selected.appointmentsToday
                  ? Colors.white
                  : Colors.transparent,
              child: ListTile(
                title: Text(
                  'Appointments Today',
                  style: l.copyWith(
                    color: selected == Selected.appointmentsToday
                        ? blue
                        : Colors.white,
                  ),
                ),
                trailing: Icon(Icons.schedule,
                    color: selected == Selected.appointmentsToday
                        ? blue
                        : Colors.white,
                    size: 30),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            Container(
              color: selected == Selected.findDoctors
                  ? Colors.white
                  : Colors.transparent,
              child: ListTile(
                title: Text(
                  'Find Doctors',
                  style: l.copyWith(
                    color:
                        selected == Selected.findDoctors ? blue : Colors.white,
                  ),
                ),
                trailing: Icon(Icons.search,
                    color:
                        selected == Selected.findDoctors ? blue : Colors.white,
                    size: 30),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            Container(
              color: selected == Selected.appointments
                  ? Colors.white
                  : Colors.transparent,
              child: ListTile(
                title: Text(
                  'Appointments',
                  style: l.copyWith(
                    color:
                        selected == Selected.appointments ? blue : Colors.white,
                  ),
                ),
                trailing: Icon(Icons.insert_invitation,
                    color:
                        selected == Selected.appointments ? blue : Colors.white,
                    size: 30),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            Container(
              color: selected == Selected.prescriptions
                  ? Colors.white
                  : Colors.transparent,
              child: ListTile(
                title: Text(
                  'Prescriptions',
                  style: l.copyWith(
                    color: selected == Selected.prescriptions
                        ? blue
                        : Colors.white,
                  ),
                ),
                trailing: Icon(Icons.content_paste,
                    color: selected == Selected.prescriptions
                        ? blue
                        : Colors.white,
                    size: 30),
              ),
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
