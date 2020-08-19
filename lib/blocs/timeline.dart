import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../models/timeline.dart';
import '../models/transaction.dart';
import '../networking/response.dart';
import '../repositories/timeline.dart';
import '../repositories/transaction.dart';

class TimelineBloc extends ChangeNotifier implements BaseBloc {
  TimelineRepository _timelineRepository;
  TransactionRepository _transactionRepository;
  StreamController _timelineController;
  Appointment _appointment;

  StreamSink<Response<List<Timeline>>> get sink => _timelineController.sink;

  Stream<Response<List<Timeline>>> get stream => _timelineController.stream;

  TimelineBloc(this._appointment) {
    _timelineRepository = TimelineRepository();
    _transactionRepository = TransactionRepository();
    _timelineController = StreamController<Response<List<Timeline>>>();
    fetchTimeline();
  }

  void fetchTimeline() async {
    sink.add(Response.loading('Fetching Timeline'));
    try {
      final list = await _timelineRepository.getTimelines(_appointment);
      sink.add(Response.completed(list));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionRepository.addTransaction(transaction);
    fetchTimeline();
  }

  Future<Transaction> getTransaction(String appointmentId) async {
    try {
      return await _transactionRepository.getTransaction(appointmentId);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    _timelineController?.close();
    super.dispose();
  }
}
