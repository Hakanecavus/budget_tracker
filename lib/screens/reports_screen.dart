import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
      ),
      body: _buildPieCharts(transactionProvider, categoryProvider, l10n),
    );
  }

  Widget _buildPieCharts(TransactionProvider transactionProvider, CategoryProvider categoryProvider, AppLocalizations l10n) {
    final incomeData = _getChartData(transactionProvider, categoryProvider, true, true, l10n);
    final expenseData = _getChartData(transactionProvider, categoryProvider, false, false, l10n);

    return SingleChildScrollView(
      child: Column(
        children: [
          if (incomeData.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.income,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: incomeData,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
          if (expenseData.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.expense,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: expenseData,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
          if (incomeData.isEmpty && expenseData.isEmpty)
            const Center(child: Text('No data to display')),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getChartData(TransactionProvider transactionProvider, CategoryProvider categoryProvider, bool isIncome, bool isIncomeChart, AppLocalizations l10n) {
    final categoryTotals = <String, double>{};

    for (final txn in transactionProvider.transactions) {
      if (txn.isIncome == isIncome) {
        categoryTotals[txn.categoryId] = (categoryTotals[txn.categoryId] ?? 0) + txn.amount;
      }
    }

    final total = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);

    final entries = categoryTotals.entries.toList();
    return entries.asMap().entries.map((mapEntry) {
      final index = mapEntry.key;
      final entry = mapEntry.value;
      final category = categoryProvider.categories.firstWhere(
        (cat) => cat.id == entry.key,
        orElse: () => Category(id: '', name: l10n.unknown, color: Colors.grey, type: isIncome ? CategoryType.income : CategoryType.expense),
      );

      final percentage = total > 0 ? (entry.value / total * 100) : 0.0;
      final isTouched = index == _touchedIndex;
      final categoryName = category.id.startsWith('unknown_') ? l10n.unknown : category.name;

      return PieChartSectionData(
        value: entry.value,
        title: isTouched ? categoryName : '${percentage.toStringAsFixed(1)}%',
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