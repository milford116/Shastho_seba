import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../blocs/previousAppointments.dart';
import '../../networking/response.dart';
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../widgets/image.dart';

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
                              onChanged: (value) {
                                appointmentsBloc.streamController.add(value);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
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
                              child: response.data.length == 0
                                  ? Center(
                                      child: Text(
                                      'You have no previous appointments',
                                      style: L,
                                    ))
                                  : ListView.builder(
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
                                                  arguments:
                                                      response.data[index],
                                                );
                                              },
                                              leading: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 23,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  // child: ShowImage(
                                                  //     response
                                                  //         .data[index].doctor.image,
                                                  //     15.0),
                                                  child: ShowImage(
                                                    response.data[index].doctor
                                                        .image,
                                                  ),
                                                ),
                                              ),
                                              title: Center(
                                                child: Text(
                                                  'Dr. ${response.data[index].doctor.name}',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
