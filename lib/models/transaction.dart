import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final double amount;
  final bool isIncome;
  final String categoryId;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.isIncome,
    required this.categoryId,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'isIncome': isIncome,
      'categoryId': categoryId,
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      isIncome: json['isIncome'],
      categoryId: json['categoryId'],
      date: DateFormat('yyyy-MM-dd').parse(json['date']),
    );
  }
}