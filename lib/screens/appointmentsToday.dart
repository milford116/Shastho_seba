import 'package:Shastho_Sheba/blocs/todayAppointments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import '../routes.dart';
import '../widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../blocs/todayAppointments.dart';
import '../networking/response.dart';
import '../models/appointment.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';

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
                                    style: M.copyWith(color: mint),
                                  )
                                : Text(
                                    'Pending',
                                    style: M.copyWith(color: red),
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
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  appointmentDetailsScreen,
                                  arguments: name,
                                );
                              },
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
          title: Text('Appointments Today'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.appointmentsToday),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => TodayAppointmentsBloc(),
            child: Builder(
              builder: (context) {
                TodayAppointmentsBloc appointmentsBloc =
                    Provider.of<TodayAppointmentsBloc>(context);
                return StreamBuilder(
                    stream: appointmentsBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<List<Appointment>> response = snapshot.data;
                        switch (response.status) {
                          case Status.LOADING:
                            return Center(
                              child: Loading(response.message),
                            );
                            break;
                          case Status.COMPLETED:
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 3.0, left: 5.0, right: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: response.data.length,
                                      itemBuilder: (context, index) {
                                        final DateTime temp =
                                            response.data[index].dateTime;
                                        final DateFormat formatter =
                                            DateFormat.jm();
                                        final String time =
                                            formatter.format(temp);

                                        int statuscode =
                                            response.data[index].status;

                                        String status;
                                        if (statuscode == 1 ||
                                            statuscode == 2) {
                                          status = 'done';
                                        } else if (statuscode == 0) {
                                          status = 'pending';
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: appointmentCard(
                                            response.data[index].doctorName,
                                            time,
                                            response.data[index].serialNo
                                                .toString(),
                                            status,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );

                          case Status.ERROR:
                            return Center(
                              child: Error(
                                message: response.message,
                                onPressed: () =>
                                    appointmentsBloc.fetchTodayAppointments(),
                              ),
                            );
                        }
                      }
                      return Container();
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
