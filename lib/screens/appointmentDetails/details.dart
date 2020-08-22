import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../widgets/dialogs.dart';
import '../../routes.dart';
import '../../models/appointment.dart';
import '../../models/timeline.dart';
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
          title: Text(appointment.doctor.name),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => TimelineBloc(appointment),
            builder: (context, child) {
              TimelineBloc timelineBloc = Provider.of<TimelineBloc>(context);
              return StreamBuilder(
                stream: timelineBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Response<List<Timeline>> response = snapshot.data;
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
                                padding: EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 20.0),
                                itemCount: response.data.length,
                                itemBuilder: (context, index) {
                                  Timeline timeline = response.data[index];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Tile(
                                          date: DateFormat('MMM dd\nyyyy')
                                              .format(timeline
                                                  .appointmentCreatedAt),
                                          color: lightBlue,
                                          message:
                                              'You created an appointment for ${DateFormat.yMMMMd('en_US').format(timeline.appointmentDate)}.',
                                          buttonBar: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              if (!timeline.hasTransaction)
                                                FlatButton(
                                                  color: blue,
                                                  onPressed: () =>
                                                      _cancelAppointment(
                                                    context,
                                                    timelineBloc,
                                                    timeline.appointmentId,
                                                    response.data.length == 1,
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Tile(
                                              date: DateFormat('MMM dd\nyyyy')
                                                  .format(timeline
                                                      .transactionCreatedAt),
                                              message:
                                                  'You have ${timeline.due}/- due.',
                                              color: lightPurple,
                                              buttonBar: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  FlatButton(
                                                    color: purple,
                                                    onPressed: () async {
                                                      await Navigator.pushNamed(
                                                        context,
                                                        transactionsScreen,
                                                        arguments: {
                                                          'appointmentId':
                                                              timeline
                                                                  .appointmentId,
                                                          'due': timeline.due,
                                                        },
                                                      );
                                                      timelineBloc
                                                          .fetchTimeline();
                                                    },
                                                    child: Text(
                                                      'View',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (timeline.hasPrescription)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Tile(
                                                date: DateFormat('MMM dd\nyyyy')
                                                    .format(timeline
                                                        .prescriptionCreatedAt),
                                                message:
                                                    'The Doctor has given you a prescription.',
                                                color: lightMint,
                                                buttonBar: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      color: mint,
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          showPrescriptionScreen,
                                                          arguments: {
                                                            'appointmentId':
                                                                timeline
                                                                    .appointmentId,
                                                            'appointmentDate':
                                                                timeline
                                                                    .prescriptionCreatedAt,
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'View',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.file_upload),
                                  label: Text('Upload Report'),
                                  color: blue,
                                ),
                                FlatButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      chamberScreen,
                                      arguments: appointment,
                                    );
                                  },
                                  icon: Icon(Icons.exit_to_app),
                                  label: Text('Enter Chamber'),
                                  color: blue,
                                ),
                              ],
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
