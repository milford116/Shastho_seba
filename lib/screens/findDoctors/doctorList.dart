import 'package:Shastho_Sheba/blocs/findDoctors.dart';
import 'package:Shastho_Sheba/models/doctor.dart';
import 'package:Shastho_Sheba/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/drawer.dart';
import '../../routes.dart';
import '../../networking/response.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';

class DoctorList extends StatefulWidget {
  @override
  _SpecialityWiseDoctorListState createState() =>
      _SpecialityWiseDoctorListState();
}

class _SpecialityWiseDoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    final String specialityname = ModalRoute.of(context).settings.arguments;
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
          title: Text('$specialityname'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.findDoctors),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => FindDoctorsBloc(specialityname),
            child: Builder(
              builder: (context) {
                FindDoctorsBloc findDoctorsBloc =
                    Provider.of<FindDoctorsBloc>(context);
                return StreamBuilder(
                  stream: findDoctorsBloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Response<List<Doctor>> response = snapshot.data;
                      switch (response.status) {
                        case Status.LOADING:
                          return Center(
                            child: Loading(response.message),
                          );
                          break;
                        case Status.COMPLETED:
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 5.0, right: 5.0),
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 30.0,
                                      color: blue,
                                    ),
                                    labelText: 'Search',
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 20.0),
                                    itemCount: response.data.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: blue,
                                                width: 2.0,
                                              )),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                doctorProfileScreen,
                                                arguments: response.data[index],
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.blue,
                                                  child: CircleAvatar(
                                                    radius: 27,
                                                    backgroundImage: AssetImage(
                                                        'images/abul_kalam.png'),
                                                  ),
                                                ),
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        response
                                                            .data[index].name,
                                                        style: M.copyWith(
                                                            color: blue),
                                                      ),
                                                      Text(
                                                        response.data[index]
                                                            .designation,
                                                        style: M.copyWith(
                                                            color: blue),
                                                      ),
                                                      Text(
                                                        response.data[index]
                                                            .institution,
                                                        style: M.copyWith(
                                                            color: blue),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // trailing: Padding(
                                                //   padding:
                                                //       const EdgeInsets.fromLTRB(
                                                //           0.0, 10.0, 10.0, 0.0),
                                                //   child: Column(
                                                //     children: <Widget>[
                                                //       Text(
                                                //         'Fee:',
                                                //         style: M.copyWith(
                                                //             color: blue),
                                                //       ),
                                                //       Text(
                                                //         response.data[index]
                                                //             .email, // not email. fee range will be shown here
                                                //         style: M.copyWith(
                                                //             color: blue),
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                              ),
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

                        case Status.ERROR:
                          return Center(
                            child: Error(
                              message: response.message,
                              onPressed: () =>
                                  findDoctorsBloc.findDoctors(specialityname),
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

List<String> names = [
  'Dr.Shafiul Islam',
  'Dr.Akbar Ali',
  'Dr.Khademul Alam',
  'Dr.Abul Kalam'
];
