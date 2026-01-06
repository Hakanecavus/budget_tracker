import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/currency_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    // Calculate month-specific totals
    final monthTransactions = transactionProvider.transactions.where((txn) {
      return txn.date.year == _focusedDay.year && txn.date.month == _focusedDay.month;
    }).toList();

    final monthIncome = monthTransactions.where((txn) => txn.isIncome).fold(0.0, (sum, txn) => sum + txn.amount);
    final monthExpense = monthTransactions.where((txn) => !txn.isIncome).fold(0.0, (sum, txn) => sum + txn.amount);
    final monthBalance = monthIncome - monthExpense;

    // Localized calendar format names
    final calendarFormats = {
      CalendarFormat.month: l10n.monthFormat,
      CalendarFormat.twoWeeks: l10n.twoWeekFormat,
      CalendarFormat.week: l10n.weekFormat,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                  Column(
                  children: [
                    Text(l10n.income, style: const TextStyle(fontSize: 16)),
                    Text('${currencyProvider.currency}${monthIncome.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                Column(
                  children: [
                    Text(l10n.expense, style: const TextStyle(fontSize: 16)),
                    Text('${currencyProvider.currency}${monthExpense.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
                Column(
                  children: [
                    Text(l10n.balance, style: const TextStyle(fontSize: 16)),
                    Text('${currencyProvider.currency}${monthBalance.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: monthBalance >= 0 ? Colors.blue : Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          TableCalendar(
            locale: localeProvider.locale.toString(),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: calendarFormats,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
              });
            },
            eventLoader: (day) {
              return transactionProvider.transactions
                  .where((txn) => isSameDay(txn.date, day))
                  .toList();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(day, events, categoryProvider),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedDay != null
                ? _buildTransactionList(_selectedDay!, transactionProvider, categoryProvider, currencyProvider, l10n)
                : Center(child: Text(l10n.selectDate)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(_selectedDay ?? DateTime.now()),
        child: const Icon(Icons.add),
      ),

    );
  }

  void _showAddTransactionDialog(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(selectedDate: date),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime day, List events, CategoryProvider categoryProvider) {
    final l10n = AppLocalizations.of(context)!;
    List<Widget> markers = [];
    for (var event in events) {
      Transaction txn = event as Transaction;
      Category? category = categoryProvider.categories.firstWhere(
        (cat) => cat.id == txn.categoryId,
        orElse: () => Category(id: '', name: l10n.unknown, color: Colors.grey, type: CategoryType.expense),
      );
      markers.add(Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category.color,
        ),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: markers.take(3).toList(), // Limit to 3 markers
    );
  }

  Widget _buildTransactionList(DateTime date, TransactionProvider transactionProvider, CategoryProvider categoryProvider, CurrencyProvider currencyProvider, AppLocalizations l10n) {
    final dayTransactions = transactionProvider.transactions
        .where((txn) => isSameDay(txn.date, date))
        .toList();

    if (dayTransactions.isEmpty) {
      return Center(child: Text(l10n.noTransactions));
    }

    return ListView.builder(
      itemCount: dayTransactions.length,
      itemBuilder: (context, index) {
        final txn = dayTransactions[index];
        final category = categoryProvider.categories.firstWhere(
          (cat) => cat.id == txn.categoryId,
          orElse: () => Category(id: '', name: l10n.unknown, color: Colors.grey, type: CategoryType.expense),
        );

        return Dismissible(
          key: Key(txn.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            final l10nDialog = AppLocalizations.of(context)!;
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(l10nDialog.confirmDelete),
                  content: Text(l10nDialog.confirmDeleteTransaction),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l10nDialog.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10nDialog.delete),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            transactionProvider.deleteTransaction(txn.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.transactionDeleted)),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color,
              child: Text(txn.isIncome ? '+' : '-'),
            ),
            title: Text(category.id.startsWith('unknown_') ? l10n.unknown : category.name),
            subtitle: Text(txn.isIncome ? l10n.income : l10n.expense),
            trailing: Text(
              '${currencyProvider.currency}${txn.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: txn.isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}