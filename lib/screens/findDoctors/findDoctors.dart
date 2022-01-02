import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translator/translator.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../widgets/drawer.dart';
class FindDoctorsScreen extends StatefulWidget {
  @override
  _Screenstate createState() => _Screenstate();
}

class _Screenstate extends State<FindDoctorsScreen> {
  GoogleTranslator translator = new GoogleTranslator();
  String out;
  
  void trans()
  {
    
    translator.translate('find doctor', to: 'bn')   //translating to hi = hindi
      .then((output) 
      {
          setState(() {
           out=output.toString();                          //placing the translated text to the String to be used
          });
          
      });
  }


  @override
  Widget build(BuildContext context) {
    //final out = await trans();
    //print(out);

    trans();
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
                'ডাক্তার খুঁজুন',
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

  Speciality(name: 'এমারজেন্সি', icon: emergency),
  Speciality(name: 'মেডিসিন', icon: pill),
  Speciality(name: 'ত্বক', icon: dermatologist),
  Speciality(name: 'ডায়াবেটিস', icon: diabetes),
  Speciality(name: 'বার্ন অ্যান্ড প্লাস্টিক', icon: burnandplastic),
  Speciality(name: 'অপথালমোলোজি', icon: eye),
  Speciality(name: 'হৃদরোগ', icon: heart),
  Speciality(name: 'নেফ্রলজি', icon: kidney),
  Speciality(name: 'হেপাটোলোজি', icon: liver),
  Speciality(name: 'পালমোলজি', icon: lungs),
  Speciality(name: 'নিউরোলজি', icon: neuron),
  Speciality(name: 'নাক,কান ,গলা', icon: nose),
  Speciality(name: 'পুষ্টি', icon: nutritionist),
  Speciality(name: 'অর্থোপেডিক', icon: orthopedic),
  Speciality(name: 'শিশু ', icon: pediatric),
  Speciality(name: 'ম্যাটারনিটি', icon: pregnant),
  Speciality(name: 'সাইকোলজি', icon: psychiartry),
  Speciality(name: 'রেডিওলোজী', icon: radiotherapy),
  Speciality(name: ' গেস্ট্রোলজি', icon: stomach),
  Speciality(name: 'দন্ত', icon: tooth),
];
