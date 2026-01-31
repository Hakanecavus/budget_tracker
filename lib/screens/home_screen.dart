import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:showcaseview/showcaseview.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/currency_provider.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../widgets/delete_dismissible_background.dart';
import '../widgets/dialogs.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey? addTransactionKey;
  const HomeScreen({super.key, this.addTransactionKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    // Calculate month-specific totals
    final monthIncome = transactionProvider.getIncomeForMonth(_focusedDay);
    final monthExpense = transactionProvider.getExpenseForMonth(_focusedDay);
    final monthBalance = transactionProvider.getBalanceForMonth(_focusedDay);

    // Localized calendar format names
    final calendarFormats = {
      CalendarFormat.month: l10n.monthFormat,
      CalendarFormat.twoWeeks: l10n.twoWeekFormat,
      CalendarFormat.week: l10n.weekFormat,
    };

    final appBarTheme = Theme.of(context).appBarTheme;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Cüzdanım',
          style: TextStyle(color: appBarTheme.foregroundColor),
        ),
        transitionBetweenRoutes: false,
        border: null,
        backgroundColor: appBarTheme.backgroundColor,
        trailing: Showcase(
          key: widget.addTransactionKey ?? GlobalKey(),
          title: l10n.tutorialAddTransactionTitle,
          description: l10n.tutorialAddTransactionDesc,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add, color: appBarTheme.foregroundColor),
            onPressed: () =>
                _showAddTransactionDialog(_selectedDay ?? DateTime.now()),
          ),
        ),
      ),
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => true,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        l10n.balance,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${currencyProvider.currency}${monthBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: monthBalance >= 0 ? Colors.green : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.income,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                '${currencyProvider.currency}${monthIncome.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.expense,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                '${currencyProvider.currency}${monthExpense.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1.0, color: Colors.grey, thickness: 1.0),
              TableCalendar(
                locale: localeProvider.locale.toString(),
                startingDayOfWeek: localeProvider.locale.languageCode == 'tr'
                    ? StartingDayOfWeek.monday
                    : StartingDayOfWeek.sunday,
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
                    _selectedDay = DateTime(
                      focusedDay.year,
                      focusedDay.month,
                      1,
                    );
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
                        child: _buildEventsMarker(
                          day,
                          events,
                          categoryProvider,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _selectedDay != null
                    ? _buildTransactionList(
                        _selectedDay!,
                        transactionProvider,
                        categoryProvider,
                        currencyProvider,
                        l10n,
                      )
                    : Center(child: Text(l10n.selectDate)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(DateTime date) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionSheet(selectedDate: date),
    );
  }

  void _showUpdateTransactionDialog(Transaction txn) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddTransactionSheet(selectedDate: txn.date, transaction: txn),
    );
  }

  Widget _buildEventsMarker(
    DateTime day,
    List events,
    CategoryProvider categoryProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    List<Widget> markers = [];
    for (var event in events) {
      Transaction txn = event as Transaction;
      Category? category = categoryProvider.categories.firstWhere(
        (cat) => cat.id == txn.categoryId,
        orElse: () => Category(
          id: '',
          name: l10n.unknown,
          color: Colors.grey,
          type: CategoryType.expense,
        ),
      );
      markers.add(
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category.color,
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: markers.take(3).toList(), // Limit to 3 markers
    );
  }

  Widget _buildTransactionList(
    DateTime date,
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
    CurrencyProvider currencyProvider,
    AppLocalizations l10n,
  ) {
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
          orElse: () => Category(
            id: '',
            name: l10n.unknown,
            color: Colors.grey,
            type: CategoryType.expense,
          ),
        );

        return Dismissible(
          key: Key(txn.id),
          direction: DismissDirection.endToStart,
          background: const DeleteDismissibleBackground(),
          confirmDismiss: (direction) async {
            final l10nDialog = AppLocalizations.of(context)!;
            return await showDeleteConfirmationDialog(
              context: context,
              title: l10nDialog.confirmDelete,
              content: l10nDialog.confirmDeleteTransaction,
              deleteText: l10nDialog.delete,
              cancelText: l10nDialog.cancel,
            );
          },
          onDismissed: (direction) {
            transactionProvider.deleteTransaction(txn.id);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.transactionDeleted)));
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color,
              child: Text(txn.isIncome ? '+' : '-'),
            ),
            title: Text(
              category.id.startsWith('unknown_') ? l10n.unknown : category.name,
            ),
            subtitle: Text(txn.isIncome ? l10n.income : l10n.expense),
            trailing: Text(
              '${currencyProvider.currency}${txn.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: txn.isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _showUpdateTransactionDialog(txn),
          ),
        );
      },
    );
  }
}
