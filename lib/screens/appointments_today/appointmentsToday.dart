import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';

class AppointmentsTodayScreen extends StatefulWidget {
  @override
  _AppointmentsTodayScreenState createState() =>
      _AppointmentsTodayScreenState();
}

class _AppointmentsTodayScreenState extends State<AppointmentsTodayScreen> {
  Widget appointmentCard(
      String name, String time, String serialno, String paymentstatus) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: blue, width: 2.5)),
      child: Card(
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 0.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 53,
                    backgroundImage: AssetImage('images/abul_kalam.png'),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '$name',
                          style: XL,
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                'Details',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: blue,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
          child: ListView(
            children: <Widget>[
              appointmentCard('Dr. Abul Kalam', '4.00 PM', '12', 'Done'),
            ],
          ),
        ),
      ),
    );
  }
}
