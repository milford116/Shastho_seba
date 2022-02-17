import 'dart:io';
import 'package:shastho_sheba/models/intermediary.dart';

import '../networking/api.dart';

class IntermedRepository {
  Api _api = Api();

  Future<Intermediary> getDetails() async {
    final data = await _api.get('/intermediary/get/details', true);
    return Intermediary.fromJson(data['intermediary']);
  }

  Future<Intermediary> uploadProfilePic(File image) async {
    final data =
        await _api.uploadImage('/intermediary/upload/profile_picture', image);
    return Intermediary.fromJson(data['intermediary']);
  }
}
