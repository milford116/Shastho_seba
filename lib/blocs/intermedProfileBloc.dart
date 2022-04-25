import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/intermediary.dart';
import '../models/intermediary.dart';

class IntermedProfileBloc extends ChangeNotifier implements BaseBloc {
  IntermedRepository _intermedRepository;
  StreamController _profileController;

  StreamSink<Response<Intermediary>> get sink => _profileController.sink;

  Stream<Response<Intermediary>> get stream => _profileController.stream;

  IntermedProfileBloc() {
    _intermedRepository = IntermedRepository();
    _profileController = StreamController<Response<Intermediary>>();
    getInterDetails();
  }

  void getInterDetails() async {
    sink.add(Response.loading('Fetching Details'));
    try {
      final data = await _intermedRepository.getDetails();
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> uploadProfilePic() async {
    var selected = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(selected.path);
    sink.add(Response.loading('Uploading Image'));
    try {
      final data = await _intermedRepository.uploadProfilePic(image);
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _profileController?.close();
    super.dispose();
  }
}
