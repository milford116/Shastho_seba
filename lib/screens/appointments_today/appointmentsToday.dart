import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';

class AppointmentsTodayScreen extends StatefulWidget {
  @override
  _AppointmentsTodayScreenState createState() =>
      _AppointmentsTodayScreenState();
}

class _AppointmentsTodayScreenState extends State<AppointmentsTodayScreen> {
  Widget appointmentcards(
      String name, String time, String serialno, String paymentstatus) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: blue, width: 2.5)),
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            height: 220,
            width: 500,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 53,
                        backgroundImage: AssetImage('images/abul_kalam.png'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 40.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        '$name',
                        style: XL,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'Time: $time',
                      style: M,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Serial No: $serialno',
                      style: M,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Payment Status: ',
                          style: M,
                        ),
                        paymentstatus.toLowerCase() == 'done'
                            ? Text(
                                'Done',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: mint,
                                ),
                              )
                            : Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: red,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: FlatButton(
                        child: Text(
                          'Details',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: blue,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/patient_background_low_opacity.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Text('Appointments'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.appointmentsToday),
        ),
        body: SafeArea(
          child: appointmentcards('Dr. Abul Kalam', '4.00 PM', '12', 'Done'),
        ),
      ),
    );
  }
}
