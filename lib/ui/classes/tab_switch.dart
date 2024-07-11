import 'package:budgetron/ui/data/colors.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colorScheme.surfaceContainerLowest),
            child: Row(children: [
              for (var tab in tabs)
                SwitchTab(valueNotifier: valueNotifier, tab: tab, theme: theme)
            ])));
  }
}

class SwitchTab extends StatelessWidget {
  final ValueNotifier<Object> valueNotifier;
  final Enum tab;
  final ThemeData theme;

  const SwitchTab({
    super.key,
    required this.valueNotifier,
    required this.tab,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _selectTab(tab),
            child: ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (context, value, Widget? child) {
                  bool isSelected = tab == valueNotifier.value;
                  return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _resolveTabColor(isSelected)),
                          child: Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, bottom: 6),
                                child: Text(
                                  tab.toString(),
                                  style: theme.textTheme.headlineMedium!.apply(
                                      color: _resolveTextColor(isSelected)),
                                )),
                          )));
                })));
  }

  void _selectTab(Enum value) => valueNotifier.value = value;

  Color _resolveTabColor(bool isSelected) => isSelected
      ? BudgetronColors.darkSurface0
      : theme.colorScheme.surfaceContainerLowest;

  Color _resolveTextColor(bool isSelected) =>
      isSelected ? BudgetronColors.darkPrimary : theme.colorScheme.primary;
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
    final theme = Theme.of(context);

    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colorScheme.surfaceContainerLowest),
            child: Row(children: [
              for (var tab in tabs)
                DisabledSwitchTab(
                    tab: tab, selectedTab: selectedTab, theme: theme)
            ])));
  }
}

class DisabledSwitchTab extends StatelessWidget {
  final Enum tab;
  final Enum selectedTab;
  final ThemeData theme;

  const DisabledSwitchTab({
    super.key,
    required this.tab,
    required this.selectedTab,
    required this.theme,
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
                  color: _resolveColor(isSelected)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: Text(tab.toString(), style: _resolveStyle(isSelected)),
              )),
            )));
  }

  Color _resolveColor(bool isSelected) => isSelected
      ? BudgetronColors.darkSurface0
      : theme.colorScheme.surfaceContainerLowest;

  TextStyle _resolveStyle(bool isSelected) => isSelected
      ? theme.textTheme.headlineMedium!
          .apply(color: BudgetronColors.darkPrimary)
      : theme.textTheme.headlineMedium!
          .apply(color: theme.colorScheme.surfaceContainerHigh);
}
