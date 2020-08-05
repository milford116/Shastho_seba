import 'package:Shastho_Sheba/utils.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final String docname = ModalRoute.of(context).settings.arguments;
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
          title: Text('$docname'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.findDoctors),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                radius: 68,
                backgroundImage: AssetImage(doc.imageurl),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Details',
              style: XL,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                doc.details,
                style: M,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Schedule',
              style: XL,
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '''
                    Sunday:   10:00 AM - 12:00 PM
                                      03:00 PM - 05:00 PM
                    Monday:   03:00 PM - 05:00 PM
                                      08:00 PM - 10:00 PM
                    Tuesday:  08:00 PM - 10:00 PM
                    ''',
                style: M,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Fee: 500 Tk',
              style: XL,
            ),
            SizedBox(
              height: 20.0,
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
      ),
    );
  }
}

class ScheduleList {
  String day;
  List<String> time;

  ScheduleList({this.day, this.time});
}

class DoctorProfileSample {
  String imageurl;
  String details;
  List<ScheduleList> schedule;

  DoctorProfileSample({this.imageurl, this.details, this.schedule});
}

//making a dummy profile for the doctor

List<String> t1 = [
  '10:00 AM - 12:00 PM',
  '03:00 PM - 05:00 PM',
];
List<String> t2 = [
  '10:00 AM - 12:00 PM',
  '03:00 PM - 05:00 PM',
  '08:00 PM - 10:00 PM',
];

ScheduleList s1 = ScheduleList(day: 'Saturday', time: t1);
ScheduleList s2 = ScheduleList(day: 'Sunday', time: t2);
ScheduleList s3 = ScheduleList(day: 'Tuesday', time: t1);
ScheduleList s4 = ScheduleList(day: 'Thursday', time: t2);
ScheduleList s5 = ScheduleList(day: 'Friday', time: t1);

List<ScheduleList> schedule = [s1, s2, s3, s4, s5];

String img = 'images/abul_kalam.png';
String details =
    'Born on April 01, 1965 in Chittagong. He achieved his Bachelor of Medicine degree in 1990 from DMC. Later, he received higher education from the University of Wales in the United Kingdom and the American College of Chest Physicians in the United States.A specialist in medical science, Prof. Islam served as the Director and a Professor at the Institute of Postgraduate Medicine and Research (IPGMR), better known as PG Hospital in Dhaka from 2000 to 2007.He was also involved with different organizations, having established many of them. He was considered the pioneer of anti-tobacco movement in Bangladesh. ';

DoctorProfileSample doc =
    DoctorProfileSample(imageurl: img, details: details, schedule: schedule);
