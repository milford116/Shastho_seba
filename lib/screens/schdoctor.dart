import 'package:Shastho_Sheba/models/doctor.dart';
import 'package:Shastho_Sheba/repositories/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/image.dart';
import '../../utils.dart';
import '../../routes.dart';

class Schdoctor extends StatelessWidget {
  @override
  DoctorsRepository _doctorsRepository = DoctorsRepository();
  Future<List<Doctor>> fetchdoctor(String name) async {
    final list = await _doctorsRepository.doctorlist(60, 0, name);

    return list;
  }

  Widget build(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;
    final String doctor_no = map['title'];
    print(doctor_no);

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
                'Doctor Details',
                style: L,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<List<Doctor>>(
              future: fetchdoctor(doctor_no),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot != null) {
                  if (snapshot.hasData) {
                    final response = snapshot.data;
                    // print(response);

                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: response.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Card(
                                    elevation: 0.1,
                                    shadowColor: Colors.black12,
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: blue,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 40.0,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius: 38.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              // child: ShowImage(
                                              //   response
                                              //       .data[index].image,
                                              //   30.0,
                                              // ),
                                              child: ShowImage(
                                                response[index].image,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Dr. ${response[index].name}',
                                                  style: M.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  response[index].designation,
                                                  style: M,
                                                ),
                                                Text(
                                                  response[index].institution,
                                                  style: M,
                                                ),
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        chambernewScreen,
                                                        arguments:
                                                            map['schedule_id'],
                                                      );
                                                    },
                                                    child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Chamber')
        ],
      ),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
