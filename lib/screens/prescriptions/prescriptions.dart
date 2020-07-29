import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/drawer.dart';

class PrescriptionsScreen extends StatelessWidget {
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
          title: Text('Prescriptions'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.prescriptions),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30.0,
                    ),
                    labelText: 'Search',
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20.0),
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: lightBlue,
                          ),
                          child: ListTile(
                            leading: Icon(Icons.person_pin,
                                size: 30.0, color: Colors.white),
                            title: Center(
                              child: Text(
                                names[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            trailing: Opacity(
                              opacity: 0.0,
                              child: Icon(Icons.person_pin),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> names = ['Dr.Shafiul Islam', 'Dr.Akbar Ali', 'Dr.Khademul Alam'];
