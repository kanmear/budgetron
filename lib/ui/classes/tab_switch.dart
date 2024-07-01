import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class BudgetronTabSwitch extends StatelessWidget {
  final ValueNotifier<Enum> valueNotifier;
  final List<Enum> tabs;

  const BudgetronTabSwitch({
    super.key,
    required this.valueNotifier,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface),
            child: Row(children: [
              for (var tab in tabs)
                SwitchTab(valueNotifier: valueNotifier, tab: tab)
            ])));
  }
}

class SwitchTab extends StatelessWidget {
  final ValueNotifier<Object> valueNotifier;
  final Enum tab;

  const SwitchTab({
    super.key,
    required this.valueNotifier,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _selectTab(tab),
            child: ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  bool isSelected = tab == valueNotifier.value;
                  return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _resolveColor(isSelected, context)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 6),
                          child: Text(tab.toString(),
                              style: _resolveStyle(isSelected)),
                        )),
                      ));
                })));
  }

  void _selectTab(Enum value) => valueNotifier.value = value;

  Color _resolveColor(bool isSelected, BuildContext context) => isSelected
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.surface;

  TextStyle _resolveStyle(bool isSelected) => isSelected
      ? BudgetronFonts.nunitoSize18Weight500White
      : BudgetronFonts.nunitoSize16Weight600;
}

class BudgetronDisabledTabSwitch extends StatelessWidget {
  final List<Enum> tabs;
  final Enum selectedTab;

  const BudgetronDisabledTabSwitch({
    super.key,
    required this.tabs,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface),
            child: Row(children: [
              for (var tab in tabs)
                DisabledSwitchTab(tab: tab, selectedTab: selectedTab)
            ])));
  }
}

class DisabledSwitchTab extends StatelessWidget {
  final Enum tab;
  final Enum selectedTab;

  const DisabledSwitchTab({
    super.key,
    required this.tab,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = tab == selectedTab;

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _resolveColor(isSelected, context)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: Text(tab.toString(),
                    style: _resolveStyle(isSelected, context)),
              )),
            )));
  }

  Color _resolveColor(bool isSelected, BuildContext context) => isSelected
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.surface;

  TextStyle _resolveStyle(bool isSelected, BuildContext context) => isSelected
      ? BudgetronFonts.nunitoSize18Weight500White
      : BudgetronFonts.nunitoSize18Weight500White
          .apply(color: Theme.of(context).colorScheme.outlineVariant);
}
