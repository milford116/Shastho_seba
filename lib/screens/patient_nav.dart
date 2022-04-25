import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../routes.dart';
import '../utils.dart';
import '../widgets/intermediary_drawer.dart';
import '../blocs/patientTableBloc.dart';
import '../models/patient.dart';
import '../networking/response.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';


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

                 Expanded(
                   child: ChangeNotifierProvider(
                     create: (context) => PatientTableBloc(),
                     child: Builder(
                       builder: (context) {
                         PatientTableBloc patientsBloc =
                         Provider.of<PatientTableBloc>(context);
                         return StreamBuilder(
                           stream: patientsBloc.stream,
                           builder: (context, snapshot) {
                             if (snapshot.hasData) {
                               Response<List<Patient>> response = snapshot.data;
                               print('printing response');
                               // print(response);
                               switch (response.status) {
                                 case Status.LOADING:
                                   return Center(
                                     child: Loading(response.message),
                                   );
                                   break;
                                 case Status.COMPLETED:
                                   if (response.data.length == 0) {
                                     return Center(
                                       child: Text(
                                         'No patients under this Intermediary',
                                         style: L,
                                       ),
                                     );
                                   }
                                   return Padding(
                                     padding: const EdgeInsets.only(
                                         top: 3.0, left: 5.0, right: 5.0),
                                     child: Column(

                                       children: <Widget>[
                                         Expanded(
                                           child: ListView.builder(
                                             shrinkWrap: true,
                                             itemCount: response.data.length,
                                             itemBuilder: (context, index) {
                                               return Padding(
                                                 padding: const EdgeInsets.symmetric(
                                                     vertical: 5.0),
                                                 child: PatientCard(
                                                   response.data[index],
                                                 ),
                                               );
                                             },
                                           ),
                                         ),
                                       ],
                                     ),
                                   );

                                 case Status.ERROR:
                                   return Center(
                                     child: Error(
                                       message: response.message,
                                       onPressed: () =>
                                           patientsBloc.getPatientTokens(),
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

           ),
        ),
    );
  }
}



class PatientCard extends StatelessWidget {
  final Patient _patient;


  PatientCard(this._patient);



  @override
  Widget build(BuildContext context) {
    Duration difference = DateTime.now().difference(_patient.dob);
    int age = (difference.inDays ~/ 365).toInt();
    return Card(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Patient Name: ${_patient.name}',
                        style: XL,
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Token no: ${_patient.patient_token}',
                        style: M,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),


                      Text(
                            'Age: ${age.toString()}',
                            style: M,
                      ),

                      SizedBox(
                        height: 10.0,
                      ),


                      Text(
                        'Gender: ${_patient.sex}',
                        style: M,
                      ),



                      SizedBox(
                        height: 12.0,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: <Widget>[
                      //     FlatButton(
                      //       child: Text(
                      //         'Details',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       color: blue,
                      //       onPressed: () {
                      //         Navigator.pushNamed(
                      //           context,
                      //           profileScreen,
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
