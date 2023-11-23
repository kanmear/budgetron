import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class BudgetronTabSwitch extends StatelessWidget {
  final ValueNotifier<Enum> valueNotifier;
  final List<Enum> tabs;
  final Function getTabName;

  const BudgetronTabSwitch(
      {super.key,
      required this.valueNotifier,
      required this.tabs,
      required this.getTabName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).colorScheme.surface),
        height: 42,
        child: Row(
          children: [
            for (var tab in tabs)
              SwitchTab(
                  valueNotifier: valueNotifier,
                  tab: tab,
                  getTabName: getTabName)
          ],
        ),
      ),
    );
  }
}

class SwitchTab extends StatelessWidget {
  final ValueNotifier<Object> valueNotifier;
  final Enum tab;
  final Function getTabName;

  const SwitchTab(
      {super.key,
      required this.valueNotifier,
      required this.tab,
      required this.getTabName});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectTab(tab),
      child: ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (BuildContext context, value, Widget? child) {
          bool isSelected = tab == valueNotifier.value ? true : false;
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: _resolveColor(isSelected, context)),
              child: Center(
                  child: Text(
                getTabName(tab),
                style: _resolveStyle(isSelected),
              )),
            ),
          );
        },
      ),
    ));
  }

  void _selectTab(Enum value) {
    valueNotifier.value = value;
  }

  Color _resolveColor(bool isSelected, BuildContext context) => isSelected
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.surface;

  TextStyle _resolveStyle(bool isSelected) => isSelected
      ? BudgetronFonts.nunitoSize18Weight500White
      : BudgetronFonts.nunitoSize16Weight600;
}
