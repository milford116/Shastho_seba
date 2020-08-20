import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../blocs/upcomingAppointments.dart';
import '../../networking/response.dart';
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';

class UpcomingAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => UpcomingAppointmentsBloc(),
        child: Builder(
          builder: (context) {
            UpcomingAppointmentsBloc appointmentsBloc =
                Provider.of<UpcomingAppointmentsBloc>(context);
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
                            top: 10.0, left: 5.0, right: 5.0),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 20.0),
                          itemCount: response.data.length,
                          itemBuilder: (context, index) {
                            DateTime date = response.data[index].dateTime;
                            DateFormat timeFormat = DateFormat('hh:mm\na');
                            DateFormat dateFormat = DateFormat('MMM dd\nyyyy');
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: lightBlue,
                                ),
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 3.0, right: 8.0),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      appointmentDetailsScreen,
                                      arguments: response.data[index],
                                    );
                                  },
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      dateFormat.format(date),
                                      textAlign: TextAlign.center,
                                      style: XS,
                                    ),
                                  ),
                                  title: Center(
                                    child: Text(
                                      response.data[index].doctor.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      timeFormat.format(
                                          response.data[index].schedule.start),
                                      textAlign: TextAlign.center,
                                      style: XS.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    case Status.ERROR:
                      return Center(
                        child: Error(
                          message: response.message,
                          onPressed: () =>
                              appointmentsBloc.fetchUpcomingAppointments(),
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
    );
  }
}
