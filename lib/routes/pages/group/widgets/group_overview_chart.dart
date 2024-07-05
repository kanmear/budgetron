import 'package:flutter/material.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/data_visualization/elements/pie_chart.dart';
import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';

class GroupOverviewChart extends StatelessWidget {
  final ValueNotifier<bool> isExpenseFilterNotifier;
  final List<Entry> entries;
  final bool isEitherOr;

  const GroupOverviewChart(
      {super.key,
      required this.entries,
      required this.isEitherOr,
      required this.isExpenseFilterNotifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isNotEmpty) {
      return ValueListenableBuilder(
          valueListenable: isExpenseFilterNotifier,
          builder: (BuildContext context, bool isExpense, Widget? child) {
            var selectedEntries = isEitherOr
                ? entries
                : entries
                    .where((entry) =>
                        entry.category.target!.isExpense == isExpense)
                    .toList();

            double totalValue =
                EntryService.calculateTotalValue(selectedEntries);
            List<PieChartData> data = _getData(selectedEntries);

            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: theme.colorScheme.surfaceContainerLowest),
                child: Column(children: [
                  ExpenseFilterTabs(isExpenseFilterNotifier,
                      isEnabled: !isEitherOr),
                  BudgetronPieChart(
                    data: data.isNotEmpty
                        ? data
                        : [
                            PieChartData(
                                color: theme.colorScheme.outline,
                                value: 1,
                                name: '')
                          ],
                    child: _formChild(totalValue, context),
                  ),
                  const SizedBox(height: 2),
                  TopThreeCategories(data: data, total: totalValue)
                ]));
          });
    } else {
      //FIX code duplication
      //FIX incorrectly displayed
      //FIX missing tabs
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: theme.colorScheme.surfaceContainerLowest),
          padding:
              const EdgeInsets.only(top: 24, left: 10, right: 10, bottom: 12),
          child: Column(children: [
            BudgetronPieChart(
                data: [
                  PieChartData(
                      color: theme.colorScheme.outline, value: 1, name: '')
                ],
                child: Center(
                    child: Text(
                  'No data to display',
                  style: theme.textTheme.bodyMedium!
                      .apply(color: theme.colorScheme.surfaceContainerHigh),
                )))
          ]));
    }
  }

  List<PieChartData> _getData(List<Object> entries) {
    Map<int, PieChartData> data = {};
    for (Entry entry in entries as List<Entry>) {
      EntryCategory category = entry.category.target!;
      int categoryId = category.id;
      if (data.containsKey(categoryId)) {
        data[categoryId] = PieChartData(
            color: CategoryService.stringToColor(category.color),
            value: entry.value.abs() + data[categoryId]!.value,
            name: category.name);
      } else {
        data.addAll({
          categoryId: PieChartData(
              color: CategoryService.stringToColor(category.color),
              value: entry.value.abs(),
              name: category.name)
        });
      }
    }

    return data.values.toList();
  }

  Widget _formChild(double value, BuildContext context) {
    return Center(
        child: Text(
      value.toStringAsFixed(2),
      style: Theme.of(context).textTheme.headlineLarge,
    ));
  }
}

class ExpenseFilterTabs extends StatelessWidget {
  final ValueNotifier<bool> isExpenseFilterNotifier;
  final bool isEnabled;

  const ExpenseFilterTabs(this.isExpenseFilterNotifier,
      {super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return const SizedBox(height: 24);
    }

    return Column(children: [
      ValueListenableBuilder(
          valueListenable: isExpenseFilterNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Row(children: [
                _filterTab(context, 'Expenses', true),
                _filterTab(context, 'Income', false)
              ]),
            );
          }),
      const SizedBox(height: 24)
    ]);
  }

  Widget _filterTab(BuildContext context, String name, bool value) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
          onTap: () => _updateFilter(value),
          child: Container(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              decoration: BoxDecoration(
                  color: isExpenseFilterNotifier.value == value
                      ? theme.colorScheme.surface
                      : theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                  child: Text(name, style: theme.textTheme.headlineMedium)))),
    );
  }

  _updateFilter(bool isExpense) {
    isExpenseFilterNotifier.value = isExpense;
  }
}

class TopThreeCategories extends StatelessWidget {
  final List<PieChartData> data;
  final double total;

  const TopThreeCategories(
      {super.key, required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<PieChartData> topCategories = data;
    topCategories.sort((a, b) => b.value.compareTo(a.value));
    if (topCategories.length > 3) {
      topCategories = topCategories.sublist(0, 3);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
      child: Column(children: [
        for (PieChartData d in topCategories)
          CategoryWithProgressBar(data: d, total: total, theme: theme)
      ]),
    );
  }
}

class CategoryWithProgressBar extends StatelessWidget {
  final PieChartData data;
  final double total;
  final ThemeData theme;

  const CategoryWithProgressBar(
      {super.key,
      required this.data,
      required this.total,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    double value = data.value;

    return Column(children: [
      const SizedBox(height: 16),
      ListTileWithProgressBar(
        leading: _getLeading(data),
        currentValue: value,
        totalValue: total,
        trailing: _getTrailing(value, total),
      )
    ]);
  }

  Widget _getLeading(PieChartData data) {
    return Row(children: [
      Icon(Icons.square_rounded, size: 18, color: data.color),
      const SizedBox(width: 4),
      Text(data.name, style: theme.textTheme.bodyMedium),
    ]);
  }

  Widget _getTrailing(double value, double total) {
    return Row(children: [
      Text(value.toStringAsFixed(2), style: theme.textTheme.labelMedium),
      const SizedBox(width: 8),
      const Text('•'),
      const SizedBox(width: 8),
      Text("${(value / total * 100).toStringAsFixed(0)}%",
          style: theme.textTheme.labelMedium)
    ]);
  }
}
