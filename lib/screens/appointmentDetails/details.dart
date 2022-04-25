import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../widgets/dialogs.dart';
import '../../routes.dart';
import '../../models/appointment.dart';
import '../../blocs/timeline.dart';
import '../../networking/response.dart';
import 'tile.dart';

class AppointmentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Appointment appointment = ModalRoute.of(context).settings.arguments;
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
          title: Text('Dr. ${appointment.doctor.name}'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        // floatingActionButton: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     FloatingActionButton(
        //       child: Icon(Icons.exit_to_app),
        //       onPressed: () {
        //         Navigator.pushNamed(
        //           context,
        //           chamberScreen,
        //           arguments: appointment,
        //         );
        //       },
        //     ),
        //     Text(
        //       'Chamber',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ],
        // ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => TimelineBloc(appointment),
            builder: (context, child) {
              TimelineBloc timelineBloc = Provider.of<TimelineBloc>(context);
              return StreamBuilder(
                stream: timelineBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Response<List<Appointment>> response = snapshot.data;
                    switch (response.status) {
                      case Status.LOADING:
                        return Center(
                          child: Loading(response.message),
                        );
                      case Status.COMPLETED:
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 75.0),
                                itemCount: response.data.length,
                                itemBuilder: (context, index) {
                                  Appointment _appointment =
                                      response.data[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    child: Tile(
                                      appointment: _appointment,
                                      onCancelAppointment: () =>
                                          _cancelAppointment(
                                        context,
                                        timelineBloc,
                                        _appointment.id,
                                        response.data.length == 1,
                                      ),
                                      // onViewTransactions: () async {
                                      //   var due = await Navigator.pushNamed(
                                      //     context,
                                      //     transactionsScreen,
                                      //     arguments: {
                                      //       'appointmentId': _appointment.id,
                                      //       'due': _appointment.due,
                                      //     },
                                      //   );
                                      //   timelineBloc.updateDue(
                                      //       due, _appointment.id);
                                      // },
                                      onShowPrescription: () {
                                        Navigator.pushNamed(
                                          context,
                                          showPrescriptionScreen,
                                          arguments: {
                                            'appointmentId': _appointment.id,
                                            'appointmentDate':
                                                _appointment.dateTime,
                                            'doctor': appointment.doctor,
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      case Status.ERROR:
                        return Center(
                          child: Error(
                            message: response.message,
                            onPressed: () => timelineBloc.fetchTimeline(),
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
    );
  }
}

void _cancelAppointment(BuildContext context, TimelineBloc timelineBloc,
    String appointmentId, bool onlyAppointment) async {
  bool confirmation =
      await confirmationDialog(context, 'This will cancel your appointment');
  if (confirmation) {
    try {
      await showProgressDialog(context, 'Please Wait');
      await timelineBloc.cancelAppointment(appointmentId);
      await hideProgressDialog();
      await successDialog(context, 'Appointment canceled successfully');
      if (onlyAppointment) {
        Navigator.popUntil(
          context,
          ModalRoute.withName(homeScreen),
        );
      } else {
        timelineBloc.fetchTimeline();
      }
    } catch (e) {
      await hideProgressDialog();
      await failureDialog(context, e.toString());
    }
  }
}
