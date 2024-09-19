import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/colors.dart';

import 'package:budgetron/utils/string_utils.dart';

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
        child: Stack(
          children: [
            const BackgroundContainer(),
            AnimatedTabSlide(
              valueNotifier: valueNotifier,
              firstTab: tabs.first,
            ),
            Row(children: [
              for (var tab in tabs)
                SwitchTab(valueNotifier: valueNotifier, tab: tab, theme: theme)
            ])
          ],
        ));
  }
}

//REFACTOR a better way to handle this?
class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surfaceContainerLowest),
      child: Row(
        children: [
          for (var _ in [0, 0])
            //NOTE this mimics how actual tabs are made to match size
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Text(
                      StringUtils.emptyString,
                      style: theme.textTheme.headlineMedium!,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AnimatedTabSlide extends StatelessWidget {
  final ValueNotifier<Enum> valueNotifier;
  final Enum firstTab;

  const AnimatedTabSlide({
    super.key,
    required this.valueNotifier,
    required this.firstTab,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          left: valueNotifier.value == firstTab
              ? 0
              : MediaQuery.of(context).size.width / 2 - 16,
          top: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: BudgetronColors.darkSurface0),
              width: MediaQuery.of(context).size.width / 2 - 24,
            ),
          ),
        );
      },
    );
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
                  return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, bottom: 6),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                  style: theme.textTheme.headlineMedium!.apply(
                                      color: value == tab
                                          ? BudgetronColors.darkPrimary
                                          : theme.colorScheme.primary),
                                  child: Text(tab.toString()),
                                )),
                          )));
                })));
  }

  _selectTab(Enum value) => valueNotifier.value = value;
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
