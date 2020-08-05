import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils.dart';
import '../widgets/drawer.dart';

class ShowPrescriptionScreen extends StatelessWidget {
  final String patientName = 'Abir Siddique';
  final String age = '24 yrs';
  final String sex = 'Male';
  final String date = '22/07/2020';

  final double cellPadding = 5.0;

  final Widget svg = SvgPicture.asset(
    stethoscope,
    height: 28,
    width: 28,
    color: blue,
  );

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
          title: Text('Prescription'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Patient Name: $patientName',
                  style: L,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('Age: $age', style: M),
                    Text('Sex: $sex', style: M),
                    Text('Date: $date', style: M),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      svg,
                      Text(
                        'Rx',
                        style: XL,
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
                          style: L.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ...symptoms
                          .asMap()
                          .map<int, Widget>(
                            (index, symptom) {
                              return MapEntry(
                                index,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
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
                          style: L.copyWith(fontWeight: FontWeight.bold),
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
                                padding: EdgeInsets.all(cellPadding),
                                child: Text(
                                  'Name',
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                child: Text(
                                  'Dose',
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                child: Text(
                                  'Duration\n(Days)',
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          ...medicines
                              .asMap()
                              .map<int, TableRow>((index, medicine) {
                                return MapEntry(
                                  index,
                                  TableRow(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Text(
                                          '${index + 1}. ${medicine['name']}',
                                          style: M,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Text(
                                          medicine['dose'],
                                          style: M,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Text(
                                          medicine['duration'],
                                          style: M,
                                          textAlign: TextAlign.center,
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
                          style: L.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ...tests
                          .asMap()
                          .map<int, Widget>(
                            (index, test) {
                              return MapEntry(
                                index,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> symptoms = ['101 Fever', 'Headache'];
List<Map<String, String>> medicines = [
  {'name': 'Napa', 'dose': '1+0+1', 'duration': '5'},
  {'name': 'Acifix', 'dose': '1+0+1', 'duration': '5'},
];
List<String> tests = [
  'Blood Culture',
  'Chest X-Ray',
];
