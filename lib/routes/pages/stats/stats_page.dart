import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/tab_switch.dart';
import 'package:budgetron/models/enums/date_period.dart';

import 'overall_chart.dart';
import 'top_spendings_chart.dart';

class StatsPage extends StatelessWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.month);
  final ValueNotifier<bool> isExpenseFilterNotifier = ValueNotifier(true);

  StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            StatsView(
                datePeriodNotifier: datePeriodNotifier,
                isExpenseFilterNotifier: isExpenseFilterNotifier),
          ],
        ));
  }
}

class StatsView extends StatelessWidget {
  const StatsView({
    super.key,
    required this.datePeriodNotifier,
    required this.isExpenseFilterNotifier,
  });

  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final ValueNotifier<bool> isExpenseFilterNotifier;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BudgetronTabSwitch(
              valueNotifier: datePeriodNotifier,
              tabs: const [DatePeriod.month, DatePeriod.year],
              getTabName: (value) => DatePeriodMap.getName(value)),
          const SizedBox(height: 24),
          OverallChart(
              datePeriodNotifier: datePeriodNotifier,
              isExpenseFilterNotifier: isExpenseFilterNotifier),
          const SizedBox(height: 24),
          TopSpendingsChart(datePeriodNotifier: datePeriodNotifier),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
