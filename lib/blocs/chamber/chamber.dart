import 'package:flutter/foundation.dart';

import 'messenger.dart';
import '../baseBloc.dart';
import '../../models/appointment.dart';
import '../../networking/api.dart';

class ChamberBloc extends ChangeNotifier implements BaseBloc {
  Api api = Api();
  Messenger messenger;
  bool _doctorStatus = false;

  set doctorStatus(bool value) {
    _doctorStatus = value;
    notifyListeners();
  }

  bool get doctorStatus => _doctorStatus;

  ChamberBloc(Appointment appointment) {
    messenger = Messenger(api.baseUrl, this);
    messenger.init(appointment);
  }

  @override
  void dispose() {
    messenger.dispose();
    super.dispose();
  }
}
