import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/currency_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../providers/locale_provider.dart';
// import '../providers/ad_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/bottom_sheet_wrapper.dart';
import '../widgets/date_picker_utils.dart';

class AddTransactionSheet extends StatefulWidget {
  final DateTime selectedDate;
  final Transaction? transaction;

  const AddTransactionSheet({
    super.key,
    required this.selectedDate,
    this.transaction,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _explanationController = TextEditingController();
  bool _isIncome = true;
  bool _isRecurring = false;
  String? _selectedCategoryId;
  late DateTime _date;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate;
    _endDate = widget.selectedDate.add(
      const Duration(days: 90),
    ); // Default 3 months
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _isIncome = widget.transaction!.isIncome;
      _selectedCategoryId = widget.transaction!.categoryId;
      _date = widget.transaction!.date;
      _explanationController.text = widget.transaction!.explanation;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      return;
    }

    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final categoryId =
        _selectedCategoryId ??
        (_isIncome ? 'unknown_income' : 'unknown_expense');

    // Validate if category exists, else fallback
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final categoryExists = categoryProvider.categories.any(
      (cat) => cat.id == categoryId,
    );
    final finalCategoryId = categoryExists
        ? categoryId
        : (_isIncome ? 'unknown_income' : 'unknown_expense');

    if (widget.transaction == null) {
      if (_isRecurring) {
        final List<Transaction> recurringTransactions = [];
        final uuid = const Uuid();
        DateTime current = _date;

        while (current.isBefore(_endDate) ||
            (current.year == _endDate.year &&
                current.month == _endDate.month &&
                current.day == _endDate.day)) {
          recurringTransactions.add(
            Transaction(
              id: uuid.v4(),
              amount: double.parse(_amountController.text),
              isIncome: _isIncome,
              categoryId: finalCategoryId,
              date: current,
              explanation: _explanationController.text,
            ),
          );

          // Move to the same day of the next month
          int nextMonth = current.month + 1;
          int nextYear = current.year;
          if (nextMonth > 12) {
            nextMonth = 1;
            nextYear++;
          }

          // Handle shorter months (e.g., Jan 31 -> Feb 28)
          int lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
          int nextDay = _date.day > lastDayOfNextMonth
              ? lastDayOfNextMonth
              : _date.day;

          current = DateTime(nextYear, nextMonth, nextDay);
        }
        transactionProvider.addTransactions(recurringTransactions);
      } else {
        final uuid = const Uuid();
        final newTransaction = Transaction(
          id: uuid.v4(),
          amount: double.parse(_amountController.text),
          isIncome: _isIncome,
          categoryId: finalCategoryId,
          date: _date,
          explanation: _explanationController.text,
        );
        transactionProvider.addTransaction(newTransaction);
      }
    } else {
      final updatedTransaction = Transaction(
        id: widget.transaction!.id,
        amount: double.parse(_amountController.text),
        isIncome: _isIncome,
        categoryId: finalCategoryId,
        date: _date,
        explanation: _explanationController.text,
      );
      transactionProvider.updateTransaction(updatedTransaction);
    }

    // Trigger Ad Logic
    // final adProvider = Provider.of<AdProvider>(context, listen: false);
    // adProvider.incrementTransactionActionCount();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter categories based on selected type
    final displayedCategories = categoryProvider.categories.where((cat) {
      return _isIncome
          ? cat.type == CategoryType.income
          : cat.type == CategoryType.expense;
    }).toList();

    return BottomSheetWrapper(
      title: widget.transaction == null
          ? l10n.addTransaction
          : l10n.editTransaction,
      onClose: () => Navigator.of(context).pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Type Segmented Control
          SizedBox(
            width: double.infinity,
            child: CupertinoSegmentedControl<bool>(
              children: {
                true: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(l10n.income),
                ),
                false: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(l10n.expense),
                ),
              },
              onValueChanged: (bool val) {
                setState(() {
                  _isIncome = val;
                  _selectedCategoryId = null; // Reset selection on type change
                });
              },
              groupValue: _isIncome,
            ),
          ),
          const SizedBox(height: 20),

          // Amount Input
          CupertinoTextField(
            controller: _amountController,
            placeholder: l10n.amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                currencyProvider.currency,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey : Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Date Picker Text
          GestureDetector(
            onTap: () => showCustomDatePicker(
              context: context,
              initialDate: _date,
              onDateTimeChanged: (val) {
                setState(() {
                  _date = val;
                });
              },
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2E)
                    : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat.yMMMd(
                      localeProvider.locale.toString(),
                    ).format(_date),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Horizontal Category List
          Text(
            l10n.category,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: displayedCategories.isEmpty
                ? Center(
                    child: Text(
                      l10n.noCategories,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayedCategories.length,
                    itemBuilder: (context, index) {
                      final category = displayedCategories[index];
                      final isSelected = _selectedCategoryId == category.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 70,
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: category.color,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 3,
                                        )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: category.color.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),

          // Recurring Toggle
          if (widget.transaction == null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.isRecurring, style: const TextStyle(fontSize: 16)),
                CupertinoSwitch(
                  value: _isRecurring,
                  onChanged: (val) {
                    setState(() {
                      _isRecurring = val;
                      if (_isRecurring && _endDate.isBefore(_date)) {
                        _endDate = _date.add(const Duration(days: 30));
                      }
                    });
                  },
                ),
              ],
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => showCustomDatePicker(
                  context: context,
                  initialDate: _endDate,
                  minimumDate: _date,
                  onDateTimeChanged: (val) {
                    setState(() {
                      _endDate = val;
                    });
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2C2C2E)
                        : const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.calendar_badge_minus,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${l10n.endDate}: ${DateFormat.yMMMd(localeProvider.locale.toString()).format(_endDate)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],

          // Explanation Input
          CupertinoTextField(
            controller: _explanationController,
            placeholder: l10n.explanation,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            maxLines: 3,
            minLines: 1,
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: Text(
                widget.transaction == null ? l10n.add : l10n.update,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
