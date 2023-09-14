import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';
import 'package:budgetron/ui/classes/data_visualization/elements/pie_chart.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/fonts.dart';

class OverallChart extends StatelessWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final ValueNotifier<bool> isExpenseFilterNotifier;

  const OverallChart(
      {super.key,
      required this.datePeriodNotifier,
      required this.isExpenseFilterNotifier});

  @override
  Widget build(BuildContext context) {
    //HACK animatedBuilder allows listening to multiple values
    return AnimatedBuilder(
      animation:
          Listenable.merge([datePeriodNotifier, isExpenseFilterNotifier]),
      builder: (BuildContext context, _) {
        return StreamBuilder<List<Entry>>(
            stream: _getEntries(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                List<Entry> entries = snapshot.data!;
                double totalValue = EntryService.calculateTotalValue(entries);
                List<PieChartData> data = _getData(entries);

                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Theme.of(context).colorScheme.background),
                    padding: const EdgeInsets.only(
                        top: 12, left: 10, right: 10, bottom: 12),
                    child: Column(
                      children: [
                        ExpenseFilterTabs(isExpenseFilterNotifier),
                        const SizedBox(height: 20),
                        BudgetronPieChart(
                          data: data,
                          child: _formChild(totalValue),
                        ),
                        const SizedBox(height: 2),
                        TopThreeCategories(data: data, total: totalValue)
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: Text(
                  'No data to display.',
                ));
              }
            });
      },
    );
  }

  Stream<List<Entry>> _getEntries() {
    DateTime now = DateTime.now();
    if (datePeriodNotifier.value == DatePeriod.month) {
      return EntryController.getEntries(
          isExpense: isExpenseFilterNotifier.value,
          period: [DateTime(now.year, now.month), DateTime.now()]);
    } else {
      return EntryController.getEntries(
          isExpense: isExpenseFilterNotifier.value,
          period: [DateTime(now.year), DateTime.now()]);
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
      ),
    );
  }
}

class ExpenseFilterTabs extends StatelessWidget {
  final ValueNotifier<bool> isExpenseFilterNotifier;

  const ExpenseFilterTabs(this.isExpenseFilterNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isExpenseFilterNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                _filterTab(context, const EdgeInsets.only(right: 12),
                    'Expenses', true),
                _filterTab(
                    context, const EdgeInsets.only(left: 12), 'Income', false),
              ],
            ));
      },
    );
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
            child: Text(name, style: BudgetronFonts.nunitoSize16Weight400),
          ),
        ));
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
        name: data.name,
        color: data.color,
        currentValue: value,
        totalValue: total,
        leftString: value.toStringAsFixed(2),
        rightString: '${(value / total * 100).toStringAsFixed(0)}%',
      )
    ]);
  }
}
