import 'package:Shastho_Sheba/utils.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';
import '../../models/doctor.dart';

import '../../utils.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../../blocs/getSchedule.dart';
import '../../networking/response.dart';
import '../../models/schedule.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final double cellPadding = 5.0;
  @override
  Widget build(BuildContext context) {
    final Doctor docobject = ModalRoute.of(context).settings.arguments;
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
          title: Text(docobject.name),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.findDoctors),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => GetScheduleBloc(docobject.mobileNo),
            child: Builder(
              builder: (context) {
                GetScheduleBloc getScheduleBloc =
                    Provider.of<GetScheduleBloc>(context);
                return StreamBuilder(
                  stream: getScheduleBloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Response<Map<String, List<Schedule>>> response =
                          snapshot.data;
                      switch (response.status) {
                        case Status.LOADING:
                          return Center(
                            child: Loading(response.message),
                          );
                          break;
                        case Status.COMPLETED:
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.blue,
                                  child: CircleAvatar(
                                    radius: 68,
                                    backgroundImage:
                                        AssetImage('images/abul_kalam.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Details',
                                  style: XL,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    docobject.about_me,
                                    style: M,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Schedule',
                                  style: XL,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.top,
                                  columnWidths: {
                                    0: FlexColumnWidth(2.0),
                                    1: FlexColumnWidth(5.0),
                                    2: FlexColumnWidth(1.0),
                                  },
                                  children: response.data.entries
                                      .map<TableRow>(
                                        (mapEntry) => TableRow(
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  EdgeInsets.all(cellPadding),
                                              child: Text(
                                                mapEntry.key,
                                                style: M,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.all(cellPadding),
                                              child: Column(
                                                children: mapEntry.value
                                                    .map<Text>(
                                                      (s) => Text(
                                                        '${DateFormat.jm().format(s.start)} - ${DateFormat.jm().format(s.end)}',
                                                        style: M,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.all(cellPadding),
                                              child: Column(
                                                children: mapEntry.value
                                                    .map<Text>(
                                                      (s) => Text(
                                                        s.fee
                                                            .toInt()
                                                            .toString(),
                                                        style: M,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                            SizedBox(),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                      ),
                                      color: blue,
                                      label: Text(
                                        'Take An Appointment',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );

                        case Status.ERROR:
                          return Center(
                            child: Error(
                              message: response.message,
                              onPressed: () => getScheduleBloc
                                  .getSchedule(docobject.mobileNo),
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
