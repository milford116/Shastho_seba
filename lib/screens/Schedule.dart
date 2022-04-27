import 'package:shastho_sheba/blocs/schedule.dart';
import 'package:shastho_sheba/models/Schedoctor.dart';
import 'package:shastho_sheba/models/doctor.dart';
import 'package:shastho_sheba/models/schedule.dart';
import 'package:shastho_sheba/repositories/schedule.dart';
import 'package:flutter/cupertino.dart';
import '../utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../routes.dart';

class Schedulescreen extends StatelessWidget {
  ScheduleRepository _scheduleRepository = ScheduleRepository();
  Future<List<Schedule>> fetchschedule() async {
    final list = await _scheduleRepository.getScheduletoday();
    return list;
  }

  Future<List<Doctor>> fetchdoc() async {
    final list = await _scheduleRepository.getdoctor();
    return list;
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule),
              Text(
                'Schedules Today',
                style: L,
              ),
            ],
          ),
        ),
        body: SafeArea(

          child: FutureBuilder<List<Schedule>>(
              future: fetchschedule(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // child: ChangeNotifierProvider(
                //   create: (context) => ScheduleTodayBloc(),
                //   child: Builder(
                //     builder: (context) {
                //       ScheduleTodayBloc scheduleTodayBloc =
                //           Provider.of<ScheduleTodayBloc>(context);
                //       return StreamBuilder(
                //         stream: scheduleTodayBloc.stream,

                if (snapshot != null) {
                  if (snapshot.hasData) {
                    final response = snapshot.data;
                    // print(response);
                    //switch (response.status) {
                    // case Status.LOADING:
                    //   return Center(
                    //     child: Loading(response.message),
                    //   );
                    //   break;
                    // case Status.COMPLETED:
                    //   if (response.data.length == 0) {
                    //     return Center(
                    //       child: Text(
                    //         'You have no appointments today',
                    //         style: L,
                    //       ),
                    //     );
                    //   }
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: response.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ScheduleCard(
                                    response[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );

                    // case Status.ERROR:
                    //   return Center(
                    //     child: Error(
                    //       message: response.message,
                    //       onPressed: () =>
                    //           scheduleTodayBloc.fetchTodayschedule(),
                    //     ),
                    //   );
                    //  }
                  }
                }
                return Container();
              }),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Schedule _schedule;
  final DateFormat formatter = DateFormat('hh:mm a');

  ScheduleCard(this._schedule);

  @override
  Widget build(BuildContext context) {
    //  print(_schedule.doctor.name);
    return FlatButton(
      onPressed: () {
        // Navigator.of(context).pushNamed(route);

        Navigator.pushNamed(
          context,
          schdoctorScreen,
          arguments: {'title':_schedule.doc_mobile_no,
            'schedule_id':_schedule.id},
        );

      },
      child: Card(
          elevation: 0.0,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: blue, width: 1.5),
            ),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Center(
                    child: Text(
                      'Dr. ${_schedule.doc_name}',
                      style: L.copyWith(color:Colors.green),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                  // _Tile(
                  //   title: _schedule.doc_mobile_no,
                  //   s:_schedule.id,
                  //   name: _schedule.doc_name,
                  //   route: schdoctorScreen,
                  // ),


                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${_schedule.day}',
                            style: XL,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Time_start: ${formatter.format(_schedule.start.toUtc())}',
                            style: M,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Time_end: ${formatter.format(_schedule.end.toUtc())}',
                            style: M,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
class _Tile extends StatelessWidget {
  final String title;
  final String s;
  final String route;
  final String name;

  _Tile({this.title, this.s, this.route, this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
            'Dr. $name',
            style: L.copyWith(color:Colors.green),
            textAlign: TextAlign.center,

          // Text(
          //   title,
          //   style: L.copyWith(color: blue),
          //   textAlign: TextAlign.center,
          // ),
      //   ],
      // ),
    );
  }
}