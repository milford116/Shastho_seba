import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../blocs/previousAppointments.dart';
import '../../networking/response.dart';
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../widgets/image.dart';
import '../appointmentDetails/tile.dart';

class PreviousAppointments extends StatelessWidget {

  final double _iconSize = 35.0;

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
                                        DateTime date = response.data[index].dateTime;
                                        DateFormat timeFormat = DateFormat('hh:mm\na');
                                        DateFormat dateFormat = DateFormat('MMM dd\nyyyy');
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
                                                  doctorProfileScreen,
                                                  arguments:
                                                      response.data[index].doctor,
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

                                                child: Row(
                                                  children: [

                                                    // if (response.data[index].status == AppointmentStatus.Finished)
                                                    //   SizedBox(
                                                    //     width: 5.0,
                                                    //   ),
                                                    if (response.data[index].status == AppointmentStatus.Finished)
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: _iconSize,
                                                            width: _iconSize,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                            ),
                                                            child: FittedBox(
                                                              child: IconButton(
                                                                icon: Icon(
                                                                  Icons.content_paste,
                                                                  size: _iconSize - 5,
                                                                ),
                                                                color: blue,
                                                                onPressed:  () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    showPrescriptionScreen,
                                                                    arguments: {
                                                                      'appointmentId': response.data[index].id,
                                                                      'appointmentDate':
                                                                      response.data[index].dateTime,
                                                                      'doctor': response.data[index].doctor,
                                                                    },
                                                                  );},


                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Prescription',
                                                            style: XS.copyWith(color: Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Dr. ${response.data[index].doctor.name}',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),



                                                  ],
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding:
                                                const EdgeInsets.only(right: 10.0),
                                                child: Text(
                                                  timeFormat.format(date),
                                                  //response.data[index].schedule.start
                                                  textAlign: TextAlign.center,
                                                  style: XS.copyWith(color: Colors.white),
                                                ),
                                              ),
                                              // Opacity(
                                              //   opacity: 0.0,
                                              //   child: Icon(Icons.person_pin),
                                              // ),
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
