import 'package:flutter/material.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/fonts.dart';
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
                    color: Theme.of(context).colorScheme.surface),
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
                child: Column(children: [
                  ExpenseFilterTabs(isExpenseFilterNotifier,
                      isEnabled: !isEitherOr),
                  BudgetronPieChart(
                    data: data.isNotEmpty
                        ? data
                        : [
                            PieChartData(
                                color: Theme.of(context).colorScheme.outline,
                                value: 1,
                                name: '')
                          ],
                    child: _formChild(totalValue),
                  ),
                  const SizedBox(height: 2),
                  TopThreeCategories(data: data, total: totalValue)
                ]));
          });
    } else {
      //FIX code duplication
      return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Theme.of(context).colorScheme.surface),
              padding: const EdgeInsets.only(
                  top: 24, left: 10, right: 10, bottom: 12),
              child: Column(children: [
                BudgetronPieChart(
                    data: [
                      PieChartData(
                          color: Theme.of(context).colorScheme.outline,
                          value: 1,
                          name: '')
                    ],
                    child: Center(
                        child: Text(
                      'No data to display',
                      style: BudgetronFonts.nunitoSize16Weight300Gray,
                    )))
              ])));
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

  Widget _formChild(double value) {
    return Center(
        child: Text(
      value.toStringAsFixed(2),
      style: BudgetronFonts.nunitoSize22Weight500,
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
            return Align(
                alignment: Alignment.centerLeft,
                child: Row(children: [
                  _filterTab(context, const EdgeInsets.only(right: 12),
                      'Expenses', true),
                  _filterTab(
                      context, const EdgeInsets.only(left: 12), 'Income', false)
                ]));
          }),
      const SizedBox(height: 24)
    ]);
  }

  InkWell _filterTab(BuildContext context, EdgeInsetsGeometry padding,
      String name, bool value) {
    return InkWell(
        onTap: () => _updateFilter(value),
        child: Padding(
            padding: padding,
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: isExpenseFilterNotifier.value == value
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent))),
                child:
                    Text(name, style: BudgetronFonts.nunitoSize16Weight400))));
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
    List<PieChartData> topCategories = data;
    topCategories.sort((a, b) => b.value.compareTo(a.value));
    if (topCategories.length > 3) {
      topCategories = topCategories.sublist(0, 3);
    }

    return Column(children: [
      for (PieChartData d in topCategories)
        CategoryWithProgressBar(data: d, total: total)
    ]);
  }
}

class CategoryWithProgressBar extends StatelessWidget {
  final PieChartData data;
  final double total;

  const CategoryWithProgressBar(
      {super.key, required this.data, required this.total});

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
      Text(data.name, style: BudgetronFonts.nunitoSize14Weight400),
    ]);
  }

  Widget _getTrailing(double value, double total) {
    return Row(children: [
      Text(value.toStringAsFixed(2),
          style: BudgetronFonts.nunitoSize14Weight300),
      const SizedBox(width: 8),
      const Text('•'),
      const SizedBox(width: 8),
      Text("${(value / total * 100).toStringAsFixed(0)}%",
          style: BudgetronFonts.nunitoSize14Weight400)
    ]);
  }
}
