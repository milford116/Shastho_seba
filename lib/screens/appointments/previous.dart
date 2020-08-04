import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../routes.dart';

class PreviousAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                ),
                labelText: 'Search',
              ),
            ),
            Expanded(
              child: ListView.builder(
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
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(appointmentDetailsScreen);
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('images/abul_kalam.png'),
                          ),
                        ),
                        title: Center(
                          child: Text(
                            names[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: Opacity(
                          opacity: 0.0,
                          child: Icon(Icons.person_pin),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> names = [
  'Dr.Shafiul Islam',
  'Dr.Akbar Ali',
  'Dr.Khademul Alam',
  'Dr.Abul Kalam'
];
