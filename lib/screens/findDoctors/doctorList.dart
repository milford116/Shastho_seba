import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/drawer.dart';
import '../../utils.dart';
import '../../routes.dart';
import '../../networking/response.dart';
import '../../blocs/findDoctors.dart';
import '../../models/doctor.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../widgets/image.dart';

class DoctorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String specialityName = ModalRoute.of(context).settings.arguments;
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
          title: Text('$specialityName'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => FindDoctorsBloc(specialityName),
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
                                  onChanged: (value) {
                                    findDoctorsBloc.streamController.add(value);
                                  },
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
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            doctorProfileScreen,
                                            arguments: response.data[index],
                                          );
                                        },
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
                                                    child: ShowImage(
                                                      response
                                                          .data[index].image,
                                                      30.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        response
                                                            .data[index].name,
                                                        style: M.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        response.data[index]
                                                            .designation,
                                                        style: M,
                                                      ),
                                                      Text(
                                                        response.data[index]
                                                            .institution,
                                                        style: M,
                                                      ),
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

                        case Status.ERROR:
                          return Center(
                            child: Error(
                              message: response.message,
                              onPressed: () =>
                                  findDoctorsBloc.findDoctors(specialityName),
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
