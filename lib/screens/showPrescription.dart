import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils.dart';
import '../widgets/drawer.dart';
import '../networking/response.dart';
import '../blocs/prescription.dart';
import '../models/prescription.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';

class ShowPrescriptionScreen extends StatelessWidget {
  final double cellPadding = 5.0;

  final Widget svg = SvgPicture.asset(
    stethoscope,
    height: 28.0,
    width: 28.0,
    color: blue,
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    String appointmentID = map['appointmentId'];
    DateTime appointmentDate = map['appointmentDate'];
    String doctorName = map['doctorName'];
    String doctorDesignation = map['doctorDesignation'];
    String doctorInstitution = map['doctorInstitution'];

    DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

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
          title: Text('Prescription'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => PrescriptionBloc(appointmentID),
            child: Builder(
              builder: (context) {
                PrescriptionBloc prescriptionBloc =
                    Provider.of<PrescriptionBloc>(context);
                return StreamBuilder(
                  stream: prescriptionBloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Response<Prescription> response = snapshot.data;
                      switch (response.status) {
                        case Status.LOADING:
                          return Center(
                            child: Loading(response.message),
                          );
                          break;
                        case Status.COMPLETED:
                          Prescription prescription = response.data;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 0.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Dr. ${doctorName}',
                                          style: M.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          doctorDesignation,
                                          style: M.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          doctorInstitution,
                                          style: M.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                            'Date: ${dateFormatter.format(appointmentDate)}',
                                            style: M.copyWith(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: blue,
                                  thickness: 4.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Patient Name: ',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              prescription.patientName,
                                              style: M,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Age: ',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              prescription.patientAge,
                                              style: M,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Gender: ',
                                          style: M.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          prescription.patientSex,
                                          style: M,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: blue,
                                      thickness: 4.0,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: <Widget>[
                                      svg,
                                      Text(
                                        'Rx',
                                        style: XL.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Symptoms',
                                          style: L.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      ...prescription.symptoms
                                          .asMap()
                                          .map<int, Widget>(
                                            (index, symptom) {
                                              return MapEntry(
                                                index,
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5.0),
                                                  child: Text(
                                                    '${index + 1}. $symptom',
                                                    style: M,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          .values
                                          .toList(),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Medicines',
                                          style: L.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Table(
                                        border: TableBorder(
                                          horizontalInside: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                          verticalInside: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        columnWidths: {0: FlexColumnWidth(2.0)},
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    EdgeInsets.all(cellPadding),
                                                child: Text(
                                                  'Name',
                                                  style: M,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.all(cellPadding),
                                                child: Text(
                                                  'Dose',
                                                  style: M,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.all(cellPadding),
                                                child: Text(
                                                  'Duration\n(Days)',
                                                  style: M,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          ...prescription.medicine
                                              .asMap()
                                              .map<int, TableRow>(
                                                  (index, medicine) {
                                                return MapEntry(
                                                  index,
                                                  TableRow(
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            cellPadding),
                                                        child: Text(
                                                          '${index + 1}. ${medicine.name}',
                                                          style: M,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            cellPadding),
                                                        child: Text(
                                                          medicine.dose,
                                                          style: M,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            cellPadding),
                                                        child: Text(
                                                          medicine.day,
                                                          style: M,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })
                                              .values
                                              .toList(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Tests',
                                          style: L.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      ...prescription.tests
                                          .asMap()
                                          .map<int, Widget>(
                                            (index, test) {
                                              return MapEntry(
                                                index,
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5.0),
                                                  child: Text(
                                                    '${index + 1}. $test',
                                                    style: M,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          .values
                                          .toList(),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Special Advices',
                                          style: L.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      ...prescription.specialAdvice
                                          .asMap()
                                          .map<int, Widget>(
                                            (index, advice) {
                                              return MapEntry(
                                                index,
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5.0),
                                                  child: Text(
                                                    '${index + 1}. $advice',
                                                    style: M,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          .values
                                          .toList(),
                                      Divider(
                                        color: blue,
                                        thickness: 4.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );

                        case Status.ERROR:
                          return Center(
                            child: Error(
                              message: response.message,
                              onPressed: () => prescriptionBloc
                                  .getPrescription(appointmentID),
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
      ),
    );
  }
}
