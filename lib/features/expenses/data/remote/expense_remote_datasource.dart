import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/expense.dart';

class ExpenseRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _expensesRef() =>
      _firestore.collection('expenses');

  /// Fetches all expenses for a user that have been updated after a given timestamp
  Future<List<Expense>> getUpdatesSince(String userId, DateTime since) async {
    if (userId.isEmpty) return [];

    final snapshot = await _expensesRef()
        .where('userId', isEqualTo: userId)
        .where('updatedAt', isGreaterThan: since.toIso8601String())
        .get();

    return snapshot.docs.map((doc) => Expense.fromJson(doc.data())).toList();
  }

  /// Pushes a list of local expenses to Firestore
  Future<void> pushExpenses(List<Expense> expenses) async {
    if (expenses.isEmpty) return;

    final batch = _firestore.batch();
    for (final exp in expenses) {
      if (exp.userId.isEmpty) continue; // Do not push guest expenses

      final docRef = _expensesRef().doc(exp.id);
      // Ensure we push data formatted correctly, marking it as synced on the server
      final data = exp.copyWith(isSynced: true).toJson();
      // Firestore expects Strings for Iso8601 dates depending on how fromJson/toJson is configured
      batch.set(docRef, data, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// Real-time stream of all user expenses from Firestore
  Stream<List<Expense>> streamUserExpenses(String userId) {
    if (userId.isEmpty) return const Stream.empty();

    return _expensesRef().where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Expense.fromJson(doc.data())).toList();
    });
  }
}
