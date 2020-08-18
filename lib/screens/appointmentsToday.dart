import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils.dart';
import '../routes.dart';
import '../widgets/drawer.dart';
import '../blocs/appointmentsToday.dart';
import '../networking/response.dart';
import '../models/appointment.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';

class AppointmentsTodayScreen extends StatelessWidget {
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
            create: (context) => AppointmentsTodayBloc(),
            child: Builder(
              builder: (context) {
                AppointmentsTodayBloc appointmentsBloc =
                    Provider.of<AppointmentsTodayBloc>(context);
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
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: AppointmentCard(
                                          response.data[index],
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
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment _appointment;
  final DateFormat formatter = DateFormat('hh:mm a');

  AppointmentCard(this._appointment);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: blue, width: 1.5),
        ),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
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
                        _appointment.doctorName,
                        style: XL,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Time: ${formatter.format(_appointment.dateTime)}',
                        style: M,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Serial No: ${_appointment.serialNo}',
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
                          _appointment.status == 1 || _appointment.status == 2
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
                                arguments: _appointment,
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
    );
  }
}
