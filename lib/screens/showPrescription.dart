import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pdfLib;

import '../utils.dart';
import '../widgets/drawer.dart';
import '../networking/response.dart';
import '../blocs/prescription.dart';
import '../models/prescription.dart';
import '../models/doctor.dart';
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
  String patientBP = "N/A";
  String patientWeight = "N/A";
  String patientTemp = "N/A";
  String patientPulseCount = "N/A";
  String patientBloodSugar = "N/A";
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    String appointmentID = map['appointmentId'];
    DateTime appointmentDate = map['appointmentDate'];
    Doctor doctor = map['doctor'];

    DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    String date = dateFormatter.format(appointmentDate);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
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

                          if (prescription.patientBP != null)
                            patientBP = prescription.patientBP;
                          if (prescription.patientWeight != null)
                            patientWeight = prescription.patientWeight;
                          if (prescription.patientTemp != null)
                            patientTemp = prescription.patientTemp;
                          if (prescription.patientPulseCount != null)
                            patientPulseCount = prescription.patientPulseCount;
                          if (prescription.patientBloodSugar != null)
                            patientBloodSugar = prescription.patientBloodSugar;

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 0.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
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
                                                'Dr. ${doctor.name}',
                                                style: M.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                doctor.designation,
                                                style: M.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                doctor.institution,
                                                style: M.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                  'Date: ${dateFormatter.format(appointmentDate)}',
                                                  style: M.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: blue,
                                        thickness: 2.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Patient Name: ',
                                                style: M.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${prescription.patientName}',
                                                  style: M,
                                                ),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                prescription.patientSex,
                                                style: M,
                                              ),
                                              Spacer(),
                                              Text(
                                                'Age: ',
                                                style: M.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                prescription.patientAge,
                                                style: M,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: blue,
                                        thickness: 2.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Weight(Kg): ',
                                                style: M.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                patientWeight,
                                                style: M,
                                              ),
                                              Spacer(),
                                              Text(
                                                'Body Temperature: ',
                                                style: M.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                patientTemp,
                                                style: M,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Pulse Count: ',
                                                style: M.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                patientPulseCount,
                                                style: M,
                                              ),
                                              Spacer(),
                                              Text(
                                                'Blood Pressure: ',
                                                style: M.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                patientBP,
                                                style: M,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Blood Sugar Level: ',
                                                style: M.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                patientBloodSugar,
                                                style: M,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: blue,
                                        thickness: 2.0,
                                      ),
                                      SizedBox(
                                        height: 10.0,
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
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Symptoms',
                                          style: L.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                        height: 10.0,
                                      ),
                                      Table(
                                        border: TableBorder(
                                          horizontalInside: BorderSide(
                                            color: blue,
                                            width: 2.0,
                                          ),
                                          verticalInside: BorderSide(
                                            color: blue,
                                            width: 2.0,
                                          ),
                                        ),
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        columnWidths: {
                                          0: FlexColumnWidth(3.0),
                                          1: FlexColumnWidth(3.0),
                                        },
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
                                                  'Days',
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
                                        height: 10.0,
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
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  child: Text(
                                    'Download PDF',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.blue,
                                  onPressed: () => _generatePdfAndView(
                                    context,
                                    doctor: doctor,
                                    prescription: prescription,
                                    date: date,
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

  void _generatePdfAndView(
    BuildContext context, {
    Doctor doctor,
    Prescription prescription,
    String date,
  }) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    List<String> temp = doctor.name.split(" ");
    String docFirstName = temp[0];

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Text('Dr. ${doctor.name}'),
          pdfLib.Text(
              '${doctor.designation},                                                                                               Date: $date'),
          pdfLib.Text('${doctor.institution}.'),
          pdfLib.Text('\n\n\n\n'),
          pdfLib.Text('Patient Name: ${prescription.patientName}'),
          pdfLib.Text(
              'Gender: ${prescription.patientSex}      Age: ${prescription.patientAge}'),
          pdfLib.Text('\n\n\n'),
          pdfLib.Text(
              'Weight(Kg): ${patientWeight}                     Body Temperature: ${patientTemp}                       Pulse Count: ${patientPulseCount}'),
          pdfLib.Text(
              'Blood Pressure: ${patientBP}                 Blood Sugar Level: ${patientBloodSugar}'),
          pdfLib.Text('\n\n\n\n'),
          pdfLib.Center(
            child: pdfLib.Text('Symptoms'),
          ),
          ...prescription.symptoms.map((e) => pdfLib.Text('* $e')),
          pdfLib.Text('\n\n\n'),
          pdfLib.Center(
            child: pdfLib.Text('Medicine List'),
          ),
          pdfLib.Text('\n'),
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Medicine Name', 'dose', 'day'],
            ...prescription.medicine
                .map((item) => [item.name, item.dose, item.day])
          ]),
          pdfLib.Text('\n\n\n'),
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Tests'],
            ...prescription.tests.map((item) => [item])
          ]),
          pdfLib.Text('\n\n\n'),
          pdfLib.Center(
            child: pdfLib.Text('Special Advices'),
          ),
          ...prescription.specialAdvice.map((e) => pdfLib.Text('* $e')),
        ],
      ),
    );

    //Save the document
    var bytes = await pdf.save();
    //Get external storage directory
    Directory directory = await getExternalStorageDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File(
        '$path/P_Dr. ${docFirstName}_${date}_${prescription.patientName}.pdf');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open(
        '$path/P_Dr. ${docFirstName}_${date}_${prescription.patientName}.pdf');
  }
}
