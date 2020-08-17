import 'package:flutter/foundation.dart';

import 'messenger.dart';
import '../baseBloc.dart';
import '../../models/appointment.dart';
import '../../networking/api.dart';

class ChamberBloc extends ChangeNotifier implements BaseBloc {
  Api api = Api();
  Messenger messenger;

  ChamberBloc(Appointment appointment) {
    messenger = Messenger(api.baseUrl);
    messenger.init(appointment);
  }

  @override
  void dispose() {
    messenger.dispose();
    super.dispose();
  }
}
