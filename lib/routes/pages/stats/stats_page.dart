import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/date_period_tab_switch.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/ui/icons.dart';

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
        body: ListView(
          children: [
            const BudgetronAppBarWithTitle(
                title: 'Statistics', leftIconButton: MenuIconButton()),
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
        ));
  }
}
