import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/locale_provider.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';
import '../providers/currency_provider.dart';

class ReportsScreen extends StatefulWidget {
  final GlobalKey? reportsContentKey;
  const ReportsScreen({super.key, this.reportsContentKey});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _currentTabIndex = 0; // Default to Income
  int? _touchedIncomeIndex;
  int? _touchedExpenseIndex;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    final months = List.generate(
      12,
      (index) => DateFormat(
        'MMMM',
        localeProvider.locale.toString(),
      ).format(DateTime(2020, index + 1, 1)),
    );

    final years = List.generate(11, (index) => 2020 + index);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarTheme = Theme.of(context).appBarTheme;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          l10n.reports,
          style: TextStyle(color: appBarTheme.foregroundColor),
        ),
        transitionBetweenRoutes: false,
        border: null,
        backgroundColor: appBarTheme.backgroundColor,
      ),
      child: SafeArea(
        child: Showcase(
          key: widget.reportsContentKey ?? GlobalKey(),
          title: l10n.tutorialReportsTitle,
          description: l10n.tutorialReportsDesc,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Month Picker
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: Text(
                          months[_selectedMonth - 1],
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        onPressed: () => _showMonthPicker(context, months),
                      ),
                      const SizedBox(width: 16),
                      // Year Picker
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: Text(
                          _selectedYear.toString(),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        onPressed: () => _showYearPicker(context, years),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildPieCharts(
                    transactionProvider,
                    categoryProvider,
                    currencyProvider,
                    l10n,
                  ),
                ),
                CupertinoTabBar(
                  currentIndex: _currentTabIndex,
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.arrow_up_circle),
                      label: l10n.income,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.arrow_down_circle),
                      label: l10n.expense,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context, List<String> months) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedMonth - 1,
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedMonth = index + 1;
                  });
                },
                children: months.map((m) => Center(child: Text(m))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context, List<int> years) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: years.indexOf(_selectedYear),
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedYear = years[index];
                  });
                },
                children: years
                    .map((y) => Center(child: Text(y.toString())))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieCharts(
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
    CurrencyProvider currencyProvider,
    AppLocalizations l10n,
  ) {
    final isIncome = _currentTabIndex == 0;
    final touchedIndex = isIncome ? _touchedIncomeIndex : _touchedExpenseIndex;

    final chartData = _getChartData(
      transactionProvider,
      categoryProvider,
      currencyProvider,
      isIncome,
      touchedIndex,
      l10n,
    );

    if (chartData.isEmpty) {
      return Center(child: Text(l10n.noTransactions));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isIncome ? l10n.income : l10n.expense,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: chartData,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        if (isIncome) {
                          _touchedIncomeIndex = -1;
                        } else {
                          _touchedExpenseIndex = -1;
                        }
                        return;
                      }
                      final newIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;

                      if (isIncome) {
                        _touchedIncomeIndex = newIndex;
                      } else {
                        _touchedExpenseIndex = newIndex;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryList(
            transactionProvider,
            categoryProvider,
            currencyProvider,
            isIncome,
            l10n,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
    CurrencyProvider currencyProvider,
    bool isIncome,
    AppLocalizations l10n,
  ) {
    final categoryTotals = <String, double>{};

    for (final txn in transactionProvider.transactions) {
      if (txn.isIncome == isIncome &&
          txn.date.month == _selectedMonth &&
          txn.date.year == _selectedYear) {
        categoryTotals[txn.categoryId] =
            (categoryTotals[txn.categoryId] ?? 0) + txn.amount;
      }
    }

    final total = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by amount descending

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.breakdown,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...entries.map((entry) {
            final category = categoryProvider.categories.firstWhere(
              (cat) => cat.id == entry.key,
              orElse: () => Category(
                id: '',
                name: l10n.unknown,
                color: Colors.grey,
                type: isIncome ? CategoryType.income : CategoryType.expense,
              ),
            );

            final percentage = total > 0 ? (entry.value / total * 100) : 0.0;
            final categoryName = category.id.startsWith('unknown_')
                ? l10n.unknown
                : category.name;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${currencyProvider.currency}${entry.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.total,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${currencyProvider.currency}${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getChartData(
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
    CurrencyProvider currencyProvider,
    bool isIncome,
    int? touchedIndex,
    AppLocalizations l10n,
  ) {
    final categoryTotals = <String, double>{};

    for (final txn in transactionProvider.transactions) {
      if (txn.isIncome == isIncome &&
          txn.date.month == _selectedMonth &&
          txn.date.year == _selectedYear) {
        categoryTotals[txn.categoryId] =
            (categoryTotals[txn.categoryId] ?? 0) + txn.amount;
      }
    }

    final total = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    final entries = categoryTotals.entries.toList();
    return entries.asMap().entries.map((mapEntry) {
      final index = mapEntry.key;
      final entry = mapEntry.value;
      final category = categoryProvider.categories.firstWhere(
        (cat) => cat.id == entry.key,
        orElse: () => Category(
          id: '',
          name: l10n.unknown,
          color: Colors.grey,
          type: isIncome ? CategoryType.income : CategoryType.expense,
        ),
      );

      final percentage = total > 0 ? (entry.value / total * 100) : 0.0;
      final isTouched = index == touchedIndex;
      final categoryName = category.id.startsWith('unknown_')
          ? l10n.unknown
          : category.name;

      final valueString =
          '${currencyProvider.currency}${entry.value.toStringAsFixed(2)}';

      return PieChartSectionData(
        value: entry.value,
        title: isTouched
            ? '$categoryName\n$valueString'
            : '${percentage.toStringAsFixed(1)}%',
        color: category.color,
        radius: isTouched ? 110 : 100,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
