import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../routes.dart';
import '../../models/appointment.dart';
import '../../models/timeline.dart';
import '../../models/transaction.dart';
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
                                  bool hasTransaction =
                                      timeline.transactionId != null;
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
                                              'You created an appointment for ${DateFormat.yMMMMd('en_US').format(timeline.appointmentDate)}',
                                          buttonBar: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                color: blue,
                                                onPressed: () {},
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
                                      hasTransaction
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Tile(
                                                    date: DateFormat(
                                                            'MMM dd\nyyyy')
                                                        .format(timeline
                                                            .transactionCreatedAt),
                                                    message:
                                                        'You provided payment.',
                                                    color: lightPurple,
                                                    buttonBar: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        FlatButton(
                                                          color: purple,
                                                          onPressed: () =>
                                                              _viewPayment(
                                                            context,
                                                            timelineBloc,
                                                            timeline
                                                                .appointmentId,
                                                          ),
                                                          child: Text(
                                                            'View',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                timeline.hasPrescription
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Tile(
                                                          date: DateFormat(
                                                                  'MMM dd\nyyyy')
                                                              .format(timeline
                                                                  .prescriptionCreatedAt),
                                                          message:
                                                              'The Doctor has given you a prescription.',
                                                          color: lightMint,
                                                          buttonBar: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              FlatButton(
                                                                color: mint,
                                                                onPressed: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      showPrescriptionScreen);
                                                                },
                                                                child: Text(
                                                                  'View',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Tile(
                                                date: DateFormat('MMM dd\nyyyy')
                                                    .format(DateTime.now()),
                                                color: lightRed,
                                                message:
                                                    'You have not provided payment',
                                                buttonBar: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      color: red,
                                                      onPressed: () =>
                                                          _addPayment(
                                                        context,
                                                        timelineBloc,
                                                        timeline.appointmentId,
                                                      ),
                                                      child: Text(
                                                        'Add',
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

void cancelAppointment() {}

void _addPayment(BuildContext context, TimelineBloc timelineBloc,
    String appointmentId) async {
  Transaction transaction = await showDialog(
    context: context,
    builder: (context) {
      TextEditingController transaction = TextEditingController();
      TextEditingController amount = TextEditingController();
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: transaction,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                icon: Icon(Icons.phone_android),
              ),
            ),
            TextField(
              controller: amount,
              decoration: InputDecoration(
                labelText: 'Amount',
                icon: Icon(Icons.phone_android),
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop<Transaction>(
                context,
                Transaction(
                  appointmentId: appointmentId,
                  transactionId: transaction.text,
                  amount: int.parse(amount.text),
                ),
              );
            },
            child: Text('Add'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: red),
            ),
          ),
        ],
      );
    },
  );
  if (transaction != null) {
    try {
      await timelineBloc.addTransaction(transaction);
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Transaction Added Successfully'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.toString()),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}

void _viewPayment(BuildContext context, TimelineBloc timelineBloc,
    String appointmentId) async {
  Transaction transaction = await timelineBloc.getTransaction(appointmentId);
  if (transaction != null) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Trx ID: ${transaction.transactionId}'),
            Text('Amount: ${transaction.amount}'),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok'),
          ),
        ],
      ),
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Something went wrong'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}

void showPrescription() {}
