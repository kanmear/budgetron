import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/ui/classes/date_selector.dart';
import 'package:budgetron/models/enums/date_period.dart';

import 'overall_chart.dart';
import 'top_spendings_chart.dart';

class StatsPage extends StatelessWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.month);
  final ValueNotifier<List<DateTime>> dateTimeNotifier =
      ValueNotifier(BudgetronDateUtils.calculateDateRange(BudgetronPage.stats));
  //TODO check that isExpense is needed here and not in overall chart after finishing Stats
  final ValueNotifier<bool> isExpenseFilterNotifier = ValueNotifier(true);

  StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            StatsView(
              datePeriodNotifier: datePeriodNotifier,
              isExpenseFilterNotifier: isExpenseFilterNotifier,
              dateTimeNotifier: dateTimeNotifier,
            ),
          ],
        ));
  }
}

class StatsView extends StatelessWidget {
  const StatsView({
    super.key,
    required this.isExpenseFilterNotifier,
    required this.datePeriodNotifier,
    required this.dateTimeNotifier,
  });

  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final ValueNotifier<bool> isExpenseFilterNotifier;

  @override
  Widget build(BuildContext context) {
    final earliestDate = Provider.of<AppData>(context).earliestEntryDate;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                OverallChart(
                    dateTimeNotifier: dateTimeNotifier,
                    isExpenseFilterNotifier: isExpenseFilterNotifier),
                const SizedBox(height: 24),
                TopSpendingsChart(dateTimeNotifier: dateTimeNotifier),
              ],
            ),
          ),
          DateSelector(
              datePeriodNotifier: datePeriodNotifier,
              dateTimeNotifier: dateTimeNotifier,
              earliestDate: earliestDate,
              periodItems: const [DatePeriod.month, DatePeriod.year]),
        ],
      ),
    );
  }
}
