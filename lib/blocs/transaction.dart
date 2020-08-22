import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/transaction.dart';
import '../networking/response.dart';
import '../repositories/transaction.dart';

class TransactionBloc extends ChangeNotifier implements BaseBloc {
  TransactionRepository _transactionRepository;
  StreamController _transactionController;
  List<Transaction> _transactionList;
  String _appointmentId;
  double _due;
  double total;

  StreamSink<Response<List<Transaction>>> get sink =>
      _transactionController.sink;

  Stream<Response<List<Transaction>>> get stream =>
      _transactionController.stream;

  double get fee => total + _due;

  TransactionBloc(this._appointmentId, this._due) {
    _transactionRepository = TransactionRepository();
    _transactionController = StreamController<Response<List<Transaction>>>();
    fetchTransactions();
  }

  void fetchTransactions() async {
    sink.add(Response.loading('Fetching Transactions'));
    try {
      _transactionList =
          await _transactionRepository.getTransactions(_appointmentId);
      total = 0.0;
      _transactionList.forEach((element) => total = total + element.amount);
      sink.add(Response.completed(_transactionList));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionRepository.addTransaction(transaction);
    _transactionList.add(transaction);
    total = total + transaction.amount;
    _due = _due - transaction.amount;
    notifyListeners();
  }

  @override
  void dispose() {
    _transactionController?.close();
    super.dispose();
  }
}
