import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddTransactionScreen({super.key, required this.selectedDate});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isIncome = true;
  String? _selectedCategoryId;
  DateTime _date;

  _AddTransactionScreenState() : _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;


    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addTransaction),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: l10n.amount),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('${l10n.type}:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _isIncome,
                          onChanged: (value) {
                            setState(() {
                              _isIncome = value!;
                            });
                          },
                        ),
                        Text(l10n.income),
                        Radio<bool>(
                          value: false,
                          groupValue: _isIncome,
                          onChanged: (value) {
                            setState(() {
                              _isIncome = value!;
                            });
                          },
                        ),
                        Text(l10n.expense),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(labelText: l10n.category),
                items: categoryProvider.categories
                    .where((category) =>
                        (_isIncome && category.type == CategoryType.income) ||
                        (!_isIncome && category.type == CategoryType.expense))
                    .map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: category.color,
                          radius: 10,
                        ),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
                Row(
                  children: [
                    Text('${l10n.date}:'),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(DateFormat.yMd(localeProvider.locale.toString()).format(_date)),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
                    final uuid = Uuid();
                    final categoryId = _selectedCategoryId ?? (_isIncome ? 'unknown_income' : 'unknown_expense');
                    final newTransaction = Transaction(
                      id: uuid.v4(),
                      amount: double.parse(_amountController.text),
                      isIncome: _isIncome,
                      categoryId: categoryId,
                      date: _date,
                    );
                    transactionProvider.addTransaction(newTransaction);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(l10n.saveTransaction),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }
}