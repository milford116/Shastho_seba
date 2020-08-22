import '../networking/api.dart';
import '../models/transaction.dart';

class TransactionRepository {
  Api _api = Api();

  Future<String> addTransaction(Transaction transaction) async {
    final data = await _api.post('/patient/add/transaction', true, {
      'appointment_id': transaction.appointmentId,
      'transaction_id': transaction.transactionId,
      'amount': transaction.amount,
    });
    return data['message'];
  }

  Future<Transaction> getTransaction(String appointmentId) async {
    final data = await _api.post(
        '/patient/get/transaction', true, {'appointment_id': appointmentId});
    return Transaction.fromJson(data['transactions'][0]);
  }

  Future<List<Transaction>> getTransactions(String appointmentId) async {
    final data = await _api.post(
        '/patient/get/transaction', true, {'appointment_id': appointmentId});
    return data['transactions']
        .map<Transaction>((json) => Transaction.fromJson(json))
        .toList();
  }
}
