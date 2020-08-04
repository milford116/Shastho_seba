import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../routes.dart';
import 'tile.dart';

class AppointmentDetails extends StatelessWidget {
  final String doctorName = 'Dr.Shafiul Islam';

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
          title: Text(doctorName),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  children: <Widget>[
                    Tile(
                      date: 'Jul 10\n2020',
                      message: 'You created an appointment for July 20,2020.',
                      color: lightRed,
                      buttonBar: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            color: red,
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
                    SizedBox(
                      height: 15.0,
                    ),
                    Tile(
                      date: 'Jul 12\n2020',
                      message: 'You provided payment.',
                      color: lightPurple,
                      buttonBar: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            color: purple,
                            onPressed: () {},
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
                    SizedBox(
                      height: 15.0,
                    ),
                    Tile(
                      date: 'Jul 22\n2020',
                      message: 'Video call with Doctor.',
                      color: lightBlue,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Tile(
                      date: 'Jul 22\n2020',
                      message: 'The Doctor has given you a prescription.',
                      color: lightMint,
                      buttonBar: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            color: mint,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, showPrescriptionScreen);
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
                  ],
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
                    onPressed: () {},
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Enter Chamber'),
                    color: blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
