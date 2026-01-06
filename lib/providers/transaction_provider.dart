import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  static const String _transactionsKey = 'transactions';

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    _transactions = transactionsJson.map((json) => Transaction.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = _transactions.map((txn) => jsonEncode(txn.toJson())).toList();
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _saveTransactions();
    notifyListeners();
  }

  void updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere((txn) => txn.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      _saveTransactions();
      notifyListeners();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((txn) => txn.id == id);
    _saveTransactions();
    notifyListeners();
  }

  double get totalIncome {
    return _transactions.where((txn) => txn.isIncome).fold(0.0, (sum, txn) => sum + txn.amount);
  }

  double get totalExpense {
    return _transactions.where((txn) => !txn.isIncome).fold(0.0, (sum, txn) => sum + txn.amount);
  }

  double get balance => totalIncome - totalExpense;
}