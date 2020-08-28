import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../networking/response.dart';
import '../utils.dart';
import '../widgets/drawer.dart';
import '../blocs/transaction.dart';
import '../models/transaction.dart';
import '../widgets/loading.dart';
import '../widgets/dialogs.dart';
import '../widgets/error.dart';

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;
    String appointmentId = map['appointmentId'];
    double due = map['due'];
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
          title: Text('Transactions'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => TransactionBloc(appointmentId, due),
            builder: (context, child) {
              TransactionBloc transactionBloc =
                  Provider.of<TransactionBloc>(context);
              return StreamBuilder(
                stream: transactionBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Response<List<Transaction>> response = snapshot.data;
                    switch (response.status) {
                      case Status.LOADING:
                        return Center(
                          child: Loading(response.message),
                        );
                      case Status.COMPLETED:
                        double due =
                            transactionBloc.fee - transactionBloc.total;
                        Color dueColor = due > 0 ? red : mint;
                        return Stack(
                          children: [
                            ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 15.0, 10.0, 0.0),
                                  child: Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(5),
                                      2: FlexColumnWidth(2),
                                    },
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              'Date',
                                              style: L,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              'Bkash Trx ID',
                                              style: L,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7.0),
                                            child: Text(
                                              'Amount',
                                              style: L,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Table(
                                    columnWidths: response.data.length == 0
                                        ? {0: FlexColumnWidth(8)}
                                        : {
                                            0: FlexColumnWidth(3),
                                            1: FlexColumnWidth(5),
                                            2: FlexColumnWidth(2),
                                          },
                                    children: response.data.length == 0
                                        ? <TableRow>[
                                            TableRow(children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Text(
                                                  'You have not added any transactions',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ]),
                                          ]
                                        : response.data
                                            .asMap()
                                            .map(
                                              (index, transaction) => MapEntry(
                                                index,
                                                TableRow(children: <Widget>[
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.0),
                                                    child: Text(
                                                      '${index + 1}. ' +
                                                          DateFormat.yMd()
                                                              .format(transaction
                                                                  .createdAt),
                                                      style: M,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.0),
                                                    child: Text(
                                                      transaction.transactionId,
                                                      style: M,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.0),
                                                    child: Text(
                                                      transaction.amount
                                                              .toString() +
                                                          '/-',
                                                      style: M,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            )
                                            .values
                                            .toList(),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Table(
                                    columnWidths: {0: FlexColumnWidth(4)},
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(color: blue)),
                                        ),
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Text(
                                              'Total:',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Text(
                                              transactionBloc.total.toString() +
                                                  '/-',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(color: blue)),
                                        ),
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Text(
                                              'Fee:',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Text(
                                              transactionBloc.fee.toString() +
                                                  '/-',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Text(
                                              'Due:',
                                              style: M.copyWith(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Text(
                                              '$due/-',
                                              style: M.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: dueColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10.0,
                              bottom: 10.0,
                              child: FloatingActionButton(
                                onPressed: () => _addTransaction(
                                  context,
                                  transactionBloc,
                                  appointmentId,
                                ),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        );
                      case Status.ERROR:
                        return Center(
                          child: Error(
                            message: response.message,
                            onPressed: transactionBloc.fetchTransactions,
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
    );
  }
}

void _addTransaction(BuildContext context, TransactionBloc transactionBloc,
    String appointmentId) async {
  Transaction transaction = await showDialog(
    context: context,
    builder: (context) {
      TextEditingController transaction = TextEditingController();
      TextEditingController amount = TextEditingController();
      return AlertDialog(
        title: Text('Add Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: transaction,
              decoration: InputDecoration(
                labelText: 'Bkash Trx ID',
                icon: Icon(Icons.phone_android),
              ),
            ),
            TextField(
              controller: amount,
              decoration: InputDecoration(
                labelText: 'Amount',
                icon: Icon(Icons.phone_android),
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: red),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop<Transaction>(
                context,
                Transaction(
                  appointmentId: appointmentId,
                  transactionId: transaction.text,
                  amount: double.parse(amount.text),
                  createdAt: DateTime.now(),
                ),
              );
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
  if (transaction != null) {
    try {
      await showProgressDialog(context, 'Please Wait');
      await transactionBloc.addTransaction(transaction);
      await hideProgressDialog();
      await successDialog(context, 'Transaction Added Successfully');
    } catch (e) {
      await hideProgressDialog();
      await failureDialog(context, e.toString());
    }
  }
}
