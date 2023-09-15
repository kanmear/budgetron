import 'package:flutter/material.dart';

import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/ui/data/fonts.dart';

class BudgetronDatePeriodTabSwitch extends StatelessWidget {
  final ValueNotifier<DatePeriod> valueNotifier;
  final List<DatePeriod> tabs;

  const BudgetronDatePeriodTabSwitch(
      {super.key, required this.valueNotifier, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).colorScheme.background),
        height: 42,
        child: Row(
          children: [
            for (DatePeriod tab in tabs)
              Expanded(
                  child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _selectTab(tab),
                child: ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (BuildContext context, value, Widget? child) {
                    bool isSelected = tab == valueNotifier.value ? true : false;
                    return Container(
                      color: _resolveColor(isSelected, context),
                      child: Center(
                          child: Text(
                        DatePeriodMap.getName(tab),
                        style: _resolveStyle(isSelected),
                      )),
                    );
                  },
                ),
              ))
          ],
        ),
      ),
    );
  }

  void _selectTab(DatePeriod value) {
    valueNotifier.value = value;
  }

  Color _resolveColor(bool isSelected, BuildContext context) => isSelected
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.background;

  TextStyle _resolveStyle(bool isSelected) => isSelected
      ? BudgetronFonts.nunitoSize18Weight500White
      : BudgetronFonts.nunitoSize16Weight600;
}
