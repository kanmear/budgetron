import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/data_visualization/elements/pie_chart.dart';
import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';

class OverallChart extends StatelessWidget {
  const OverallChart(
      {super.key,
      required this.isExpenseFilterNotifier,
      required this.dateTimeNotifier});

  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<bool> isExpenseFilterNotifier;

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    //HACK animatedBuilder allows listening to multiple values
    return AnimatedBuilder(
      animation: Listenable.merge([isExpenseFilterNotifier, dateTimeNotifier]),
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
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLowest),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ExpenseFilterTabs(isExpenseFilterNotifier),
                        const SizedBox(height: 20),
                        BudgetronPieChart(
                          data: data,
                          child: _formChild(totalValue, currency, theme),
                        ),
                        const SizedBox(height: 2),
                        TopThreeCategories(data: data, total: totalValue)
                      ],
                    ),
                  ),
                );
              } else {
                //FIX code duplication
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLowest),
                    padding: const EdgeInsets.only(
                        top: 12, left: 10, right: 10, bottom: 12),
                    child: Column(
                      children: [
                        ExpenseFilterTabs(isExpenseFilterNotifier),
                        const SizedBox(height: 20),
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
                              style: theme.textTheme.bodyMedium!.apply(
                                  color:
                                      theme.colorScheme.surfaceContainerHigh),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            });
      },
    );
  }

  Stream<List<Entry>> _getEntries() {
    var fromDate = dateTimeNotifier.value[0];
    var toDate = dateTimeNotifier.value[1];
    // print("$fromDate, $toDate");

    return EntryController.getEntries(
        isExpense: isExpenseFilterNotifier.value, period: [fromDate, toDate]);
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

  Widget _formChild(double value, String currency, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              value.toStringAsFixed(2),
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            " $currency",
            style: theme.textTheme.headlineLarge,
          )
        ],
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
    final theme = Theme.of(context);

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
                            ? theme.colorScheme.primary
                            : Colors.transparent))),
            child: Text(name, style: theme.textTheme.headlineMedium),
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
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    double value = data.value;

    return Column(children: [
      const SizedBox(height: 16),
      ListTileWithProgressBar(
        leading: _getLeading(data, theme),
        currentValue: value,
        totalValue: total,
        trailing: _getTrailing(value, total, currency, theme),
      )
    ]);
  }

  Widget _getLeading(PieChartData data, ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.square_rounded, size: 18, color: data.color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            data.name,
            style: theme.textTheme.bodyMedium,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _getTrailing(
      double value, double total, String currency, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            "${value.toStringAsFixed(2)} $currency",
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.end,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '•',
          style: theme.textTheme.titleSmall!.apply(fontSizeFactor: 0.8),
        ),
        const SizedBox(width: 8),
        Text(
          "${(value / total * 100).toStringAsFixed(0)}%",
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
