import 'package:Shastho_Sheba/networking/response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/patient.dart';
import '../blocs/profileBloc.dart';
import '../networking/response.dart';
import '../main.dart';
import '../utils.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../widgets/image.dart';

class ProfileScreen extends StatelessWidget {
  final dateformatter = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
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
          title: Text('My Profile'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.profile),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => ProfileBloc(),
            builder: (context, child) {
              ProfileBloc profileBloc = Provider.of<ProfileBloc>(context);
              return StreamBuilder(
                stream: profileBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Response<Patient> response = snapshot.data;
                    switch (response.status) {
                      case Status.LOADING:
                        return Center(
                          child: Loading(response.message),
                        );
                      case Status.COMPLETED:
                        Patient patient = response.data;
                        return ListView(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: CircleAvatar(
                                        maxRadius: 90.0,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          maxRadius: 88.0,
                                          backgroundColor: Colors.transparent,
                                          // child: ShowImage(patient.image, 30.0),
                                          child: ShowImage(patient.image),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8.0,
                                      left: 8.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: blue,
                                        ),
                                        onPressed: profileBloc.uploadProfilePic,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'Personal Information',
                                          style: L.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Name: ${patient.name}',
                                          style: M,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Phone: ${patient.mobileNo}',
                                          style: M,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Sex: ${patient.sex}',
                                          style: M,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Date of Birth: ${dateformatter.format(MyApp.patient.dob)}',
                                          style: M,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      case Status.ERROR:
                        return Center(
                          child: Error(
                            message: response.message,
                            onPressed: profileBloc.getPatientDetails,
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
