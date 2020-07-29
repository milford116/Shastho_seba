import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';
import 'previous.dart';
import 'upcoming.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> _myTabs = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.history),
          Text('Previous'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.trending_up),
          Text('Upcoming'),
        ],
      ),
    )
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/patient_background_low_opacity.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Text('Appointments'),
          bottom: TabBar(
            controller: _tabController,
            tabs: _myTabs,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              color: Colors.white,
            ),
            labelColor: blue,
            unselectedLabelColor: Colors.white,
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.appointments),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              PreviousAppointments(),
              UpcomingAppointments(),
            ],
          ),
        ),
      ),
    );
  }
}
