import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/intermediary.dart';
import '../blocs/intermedProfileBloc.dart';
import '../networking/response.dart';
import '../utils.dart';
import '../widgets/intermediary_drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../widgets/image.dart';

class IntermediaryScreen extends StatelessWidget {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person),
              Text(
                'Intermediary\'s Profile',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.interprofile),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => IntermedProfileBloc(),
            builder: (context, child) {
              IntermedProfileBloc profileBloc = Provider.of<IntermedProfileBloc>(context);
              return StreamBuilder(
                stream: profileBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Response<Intermediary> response = snapshot.data;
                    switch (response.status) {
                      case Status.LOADING:
                        return Center(
                          child: Loading(response.message),
                        );
                      case Status.COMPLETED:
                        Intermediary intermediary = response.data;
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
                                          child: ShowImage(intermediary.image),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8.0,
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
                                          'Name: ${intermediary.name}',
                                          style: M,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Phone: ${intermediary.mobileNo}',
                                          style: M,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Gender: ${intermediary.sex}',
                                          style: M,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Age: ${intermediary.age}',
                                          style: M,
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Occupation: ${intermediary.occupation_type}',
                                          style: M,
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Location: ${intermediary.location}',
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
                            onPressed: profileBloc.getInterDetails,
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
