import 'package:flutter/material.dart';

import '../../utils.dart';

class UpcomingAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20.0),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: lightBlue,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 3.0, right: 8.0),
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'Jul 20\n2020',
                            textAlign: TextAlign.center,
                            style: XS,
                          ),
                        ),
                        title: Center(
                          child: Text(
                            names[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: Text(
                          '12:00\nPM',
                          textAlign: TextAlign.center,
                          style: XS.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

List<String> names = ['Dr.Shafiul Islam', 'Dr.Akbar Ali', 'Dr.Khademul Alam'];
