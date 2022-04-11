import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes.dart';
import '../utils.dart';
import '../widgets/intermediary_drawer.dart';
import '../blocs/intermediaryRegBloc.dart';
import '../networking/response.dart';
import '../widgets/loading.dart';

class Patient_Nav extends StatelessWidget {
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
            title: Text('Navigation'),
          ),
          drawer: SafeArea(
            child: MyDrawer(Selected.patientTokenList),
          ),
           body: SafeArea(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[


                 Container(
                   margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                   padding: EdgeInsets.all(10.0),
                   child:FlatButton(
                     child: Text(
                       'Patient-Register-login',
                       style: TextStyle(color: Colors.white),
                     ),
                     color: blue,
                     onPressed: ()
                     {
                       Navigator.pushNamed(context, patientLogScreen);
                       },
                   ),
                 ),







                 // SizedBox(
                 //   height: 20.0,
                 //   width: 150.0,
                 //   child: Divider(
                 //     color: Colors.teal.shade100,
                 //   ),
                 // ),



               ],
             ),
          // child: Center(
          //   child:FlatButton(
          //           child: Text(
          //             'Patient-Register-login',
          //             style: TextStyle(color: Colors.white),
          //           ),
          //           color: blue,
          //           onPressed: () {
          //             Navigator.pushNamed(context, loginScreen);
          //           },
          //         ),
          //   ),
           ),
        ),
    );
  }
}
