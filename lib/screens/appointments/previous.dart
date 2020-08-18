import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../blocs/previousAppointments.dart';
import '../../networking/response.dart';
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';

class PreviousAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => PreviousAppointmentsBloc(),
        child: Builder(
          builder: (context) {
            PreviousAppointmentsBloc appointmentsBloc =
                Provider.of<PreviousAppointmentsBloc>(context);
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
                                itemCount: response.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: lightBlue,
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(left: 5.0),
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            appointmentDetailsScreen,
                                            arguments: response.data[index],
                                          );
                                        },
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 23,
                                            backgroundImage: AssetImage(
                                                'images/abul_kalam.png'),
                                          ),
                                        ),
                                        title: Center(
                                          child: Text(
                                            response.data[index].doctorName,
                                            style:
                                                TextStyle(color: Colors.white),
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
                      );
                    case Status.ERROR:
                      return Center(
                        child: Error(
                          message: response.message,
                          onPressed: () =>
                              appointmentsBloc.fetchPreviousAppointments(),
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
