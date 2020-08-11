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
                            final DateTime temp = response.data[index].dateTime;

                            final DateFormat formatter1 =
                                DateFormat.MMMd('en_US');
                            final DateFormat formatter2 = DateFormat.y();
                            final DateFormat formatter3 = DateFormat.jm();

                            final String day = formatter1.format(temp);
                            final String year = formatter2.format(temp);
                            final String time = formatter3.format(temp);

                            List timesubstr = time.split(" ");

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
                                      arguments:
                                          response.data[index].doctorName,
                                    );
                                  },
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(7.0),
                                    child: Text(
                                      day + '\n' + year,
                                      textAlign: TextAlign.center,
                                      style: XS,
                                    ),
                                  ),
                                  title: Center(
                                    child: Text(
                                      response.data[index].doctorName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  trailing: Text(
                                    timesubstr[0] + '\n' + timesubstr[1],
                                    textAlign: TextAlign.center,
                                    style: XS.copyWith(color: Colors.white),
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

List<String> names = ['Dr.Shafiul Islam', 'Dr.Akbar Ali', 'Dr.Khademul Alam'];
