import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../widgets/drawer.dart';

class FindDoctorsScreen extends StatelessWidget {
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
              Icon(Icons.search),
              Text(
                'Find Doctors',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.findDoctors),
        ),
        body: SafeArea(
          child: Center(
            child: Center(
              child: GridView.count(
                childAspectRatio: 1.5,
                crossAxisCount: 2,
                children: specialities
                    .map(
                      (speciality) => _Tile(
                    title: speciality.name,
                    imageURL: speciality.icon,
                    route: specialityWiseDoctorListScreen,
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String imageURL;
  final String route;

  _Tile({
    this.title,
    this.imageURL,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    final String assetName = imageURL;
    final Widget svg = SvgPicture.asset(
      assetName,
      height: 40,
      width: 40,
    );

    return FlatButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          route,
          arguments: title,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          svg,
          Text(
            title,
            style: L.copyWith(color: blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

List<Speciality> specialities = [
  Speciality(name: 'Emergency', icon: emergency),
  Speciality(name: 'Medicine', icon: pill),
  Speciality(name: 'Dermatology', icon: dermatologist),
  Speciality(name: 'Diabetes', icon: diabetes),
  Speciality(name: 'Burn & Plastic', icon: burnandplastic),
  Speciality(name: 'Opthalmology', icon: eye),
  Speciality(name: 'Cardiology', icon: heart),
  Speciality(name: 'Nefrology', icon: kidney),
  Speciality(name: 'Hepatology', icon: liver),
  Speciality(name: 'Pulmonology', icon: lungs),
  Speciality(name: 'Neurology', icon: neuron),
  Speciality(name: 'Otolaryngology', icon: nose),
  Speciality(name: 'Nutrition', icon: nutritionist),
  Speciality(name: 'Orthopaedic', icon: orthopedic),
  Speciality(name: 'Pediatric', icon: pediatric),
  Speciality(name: 'Maternity', icon: pregnant),
  Speciality(name: 'Psychology', icon: psychiartry),
  Speciality(name: 'Radiology', icon: radiotherapy),
  Speciality(name: 'Gastroenterology', icon: stomach),
  Speciality(name: 'Dental', icon: tooth),
];