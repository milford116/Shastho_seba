import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widgets/drawer.dart';
import '../../models/doctor.dart';
import '../../models/schedule.dart';
import '../../utils.dart';
import '../../blocs/doctorProfile.dart';
import '../../networking/response.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../widgets/success.dart';
import '../../widgets/failure.dart';
import '../../widgets/image.dart';

class DoctorProfileScreen extends StatelessWidget {
  final EdgeInsets cellPadding = EdgeInsets.symmetric(vertical: 5.0);
  final dateFormatter = DateFormat('hh:mm a');
  @override
  Widget build(BuildContext context) {
    final Doctor doctor = ModalRoute.of(context).settings.arguments;
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
          title: Text(doctor.name),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => DoctorProfileBloc(doctor),
            child: Builder(
              builder: (context) {
                DoctorProfileBloc doctorProfileBloc =
                    Provider.of<DoctorProfileBloc>(context);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 68,
                          backgroundColor: Colors.transparent,
                          // child: ShowImage(doctor.image, 60.0),
                          child: ShowImage(doctor.image),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        doctor.name,
                        style: L,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        doctor.designation,
                        style: M,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        doctor.institution,
                        style: M,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          doctor.aboutMe,
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
                      StreamBuilder(
                        stream: doctorProfileBloc.stream,
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
                                return Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.top,
                                  columnWidths: {
                                    0: FlexColumnWidth(2.6),
                                    1: FlexColumnWidth(5.0),
                                    2: FlexColumnWidth(2.4),
                                  },
                                  children: <TableRow>[
                                    TableRow(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            'Day',
                                            style: M.copyWith(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            'Time',
                                            style: M.copyWith(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            'Fee',
                                            style: M.copyWith(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...response.data.entries
                                        .map<TableRow>(
                                          (mapEntry) => TableRow(
                                            children: <Widget>[
                                              Container(
                                                padding: cellPadding,
                                                child: Text(
                                                  mapEntry.key,
                                                  style: M,
                                                ),
                                              ),
                                              Container(
                                                padding: cellPadding,
                                                child: Column(
                                                  children: mapEntry.value
                                                      .map<Text>(
                                                        (s) => Text(
                                                          '${dateFormatter.format(s.start)} - ${dateFormatter.format(s.end)}',
                                                          style: M,
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                              Container(
                                                padding: cellPadding,
                                                child: Column(
                                                  children: mapEntry.value
                                                      .map<Text>(
                                                        (s) => Text(
                                                          '${s.fee.toInt().toString()}/-',
                                                          style: M,
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ],
                                );
                              case Status.ERROR:
                                return Center(
                                  child: Error(
                                    message: response.message,
                                    onPressed: () =>
                                        doctorProfileBloc.getSchedule(),
                                  ),
                                );
                            }
                          }
                          return Container();
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            onPressed: () => _takeAppointment(context),
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
              },
            ),
          ),
        ),
      ),
    );
  }
}

void _takeAppointment(BuildContext context) async {
  DoctorProfileBloc doctorProfileBloc =
      Provider.of<DoctorProfileBloc>(context, listen: false);
  DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: doctorProfileBloc.initialDate(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      selectableDayPredicate: (date) {
        return doctorProfileBloc.toShow(date.weekday);
      });
  if (date != null) {
    Schedule schedule = await showDialog<Schedule>(
      context: context,
      builder: (context) {
        return _SelectTime(date.weekday, doctorProfileBloc);
      },
    );
    if (schedule != null) {
      DateTime dateTime = DateTime.parse(
          DateFormat("yyyy-MM-dd").format(date).toString() +
              ' ' +
              DateFormat.Hms().format(schedule.start));
      print(dateTime.toLocal());
      int serialNo = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          doctorProfileBloc.createAppointment(schedule.id, dateTime).then(
                (result) => Navigator.pop<int>(context, result),
              );
          return AlertDialog(
              content: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Loading('Please Wait'),
          ));
        },
      );
      if (serialNo > 0) {
        print('Successfully Created Appointment');
        await successDialog(context,
            'Appointment Created Successfully. Your Serial is $serialNo');
      } else {
        print('Appointment Creation Failed');
        await failureDialog(context, 'Appointment Creation Failed');
      }
    }
  }
}

class _SelectTime extends StatefulWidget {
  final int weekDay;
  final DoctorProfileBloc doctorProfileBloc;

  _SelectTime(this.weekDay, this.doctorProfileBloc);
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<_SelectTime> {
  int _index = 0;
  DateFormat dateFormatter = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    List<Schedule> schedules =
        widget.doctorProfileBloc.schedules(widget.weekDay);
    return AlertDialog(
      title: Text('Select Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: schedules
            .asMap()
            .map<int, RadioListTile>((index, schedule) {
              return MapEntry(
                index,
                RadioListTile<int>(
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dateFormatter.format(schedule.start) +
                            ' - ' +
                            dateFormatter.format(schedule.end),
                      ),
                      Text('${schedule.fee}/-'),
                    ],
                  ),
                  value: index,
                  groupValue: _index,
                  onChanged: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                ),
              );
            })
            .values
            .toList(),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: red),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Submit'),
          onPressed: () {
            Navigator.pop<Schedule>(context, schedules[_index]);
          },
        ),
      ],
    );
  }
}
