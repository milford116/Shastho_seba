import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';

class AppointmentDetails extends StatelessWidget {
  final String doctorName = 'Dr.Shafiul Islam';

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
                    _Tile(
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
                    _Tile(
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
                    _Tile(
                      date: 'Jul 22\n2020',
                      message: 'Video call with Doctor.',
                      color: lightBlue,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _Tile(
                      date: 'Jul 22\n2020',
                      message: 'The Doctor has given you a prescription.',
                      color: lightMint,
                      buttonBar: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            color: mint,
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

class _Tile extends StatelessWidget {
  final String date;
  final String message;
  final Color color;
  final Widget buttonBar;
  final bool reverse;

  _Tile({
    @required this.date,
    @required this.message,
    @required this.color,
    this.reverse = false,
    this.buttonBar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: XS,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 5.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      message,
                      style: M.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                buttonBar != null ? buttonBar : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
