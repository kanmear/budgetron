import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/date_period_tab_switch.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/ui/data/icons.dart';

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            const BudgetronAppBarWithTitle(
                title: 'Statistics', leftIconButton: MenuIconButton()),
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
          BudgetronDatePeriodTabSwitch(
              valueNotifier: datePeriodNotifier,
              tabs: const [DatePeriod.month, DatePeriod.year]),
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
