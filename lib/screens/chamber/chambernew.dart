import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../widgets/drawer.dart';
import '../../blocs/chamber/chamber.dart';
import '../../models/appointment.dart';
import '../../widgets/image.dart';

class ChambernewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
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
          title: Text('Chamber'),
        ),
        // drawer: SafeArea(
        //   child: MyDrawer(Selected.none),
        // ),
        body: SafeArea(
           child: ChangeNotifierProvider(
            create: (context) => ChamberBloc(id),
            builder: (context, child) {
              ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
              chamberBloc.messenger.onCallReceive = () => Navigator.pushNamed(
                    context,
                    videoCallScreen,
                    arguments: {
                      'messenger': chamberBloc.messenger,
                      'appointment': id,
                    },
                  );
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    CircleAvatar(
                      minRadius: 75.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 73,
                        backgroundColor: Colors.transparent,
                        // child: ShowImage(appointment.doctor.image, 65.0),
                        child: ShowImage(''),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                   
                  
                    Text(
                      'Please stay here to be able to receive the Doctor\'s call.',
                    ),
                    
                    SizedBox(
                      height: 25.0,
                    ),
                    // Text('Ongoing serial:'),
                    // SizedBox(
                    //   height: 25.0,
                    // ),
                    if (chamberBloc.doctorStatus)
                      Text('The Doctor is currently online')
                    else
                      Text(
                        'The Doctor is currently offline',
                        style: TextStyle(color: red),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
