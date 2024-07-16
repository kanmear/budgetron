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

class TopSpendingsChart extends StatelessWidget {
  const TopSpendingsChart({super.key, required this.dateTimeNotifier});

  final ValueNotifier<List<DateTime>> dateTimeNotifier;

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return ValueListenableBuilder(
        valueListenable: dateTimeNotifier,
        builder: (context, value, child) {
          return StreamBuilder<List<Entry>>(
              stream: _getEntries(),
              builder: (context, snapshot) {
                if (snapshot.data?.isNotEmpty ?? false) {
                  List<Entry> entries = snapshot.data!;
                  double totalValue = EntryService.calculateTotalValue(entries);

                  List<PieChartData> data = _getData(entries);
                  double totalValueOfTopSpendings = data
                      .map((pieChartData) => pieChartData.value)
                      .reduce((value, element) => value + element);

                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: theme.colorScheme.surfaceContainerLowest),
                      padding: const EdgeInsets.only(
                          top: 12, left: 10, right: 10, bottom: 12),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Top expenditures',
                                  style: theme.textTheme.bodyMedium)),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              BudgetronPieChart(
                                  data: data,
                                  child: _formChild(
                                      totalValue,
                                      totalValueOfTopSpendings,
                                      currency,
                                      theme)),
                              const SizedBox(width: 20),
                              TopCategories(data: data, totalValue: totalValue)
                            ],
                          ),
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
                          color: theme.colorScheme.surfaceContainerLowest),
                      padding: const EdgeInsets.only(
                          top: 12, left: 10, right: 10, bottom: 12),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Top expenditures',
                                  style: theme.textTheme.bodyMedium)),
                          const SizedBox(height: 20),
                          BudgetronPieChart(
                              data: [
                                PieChartData(
                                    color: theme.colorScheme.outline,
                                    value: 1,
                                    name: '')
                              ],
                              child: Center(
                                child: Text(
                                  'No data to display',
                                  style: theme.textTheme.bodyMedium!.apply(
                                      color: theme
                                          .colorScheme.surfaceContainerHigh),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                }
              });
        });
  }

  _getEntries() {
    var fromDate = dateTimeNotifier.value[0];
    var toDate = dateTimeNotifier.value[1];
    // print("$fromDate, $toDate");

    return EntryController.getEntries(
        isExpense: true, period: [fromDate, toDate]);
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

    List<PieChartData> values = data.values.toList();
    values.sort((a, b) => b.value.compareTo(a.value));
    if (values.length > 4) {
      values = values.sublist(0, 4);
    }

    return values;
  }

  Widget _formChild(double totalValue, double totalValueOfTopSpendings,
      String currency, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              totalValueOfTopSpendings.toStringAsFixed(2),
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'of ${totalValue.toStringAsFixed(2)}',
              style: theme.textTheme.headlineLarge!
                  .apply(color: theme.colorScheme.surfaceContainerHigh),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            currency,
            style: theme.textTheme.headlineLarge!
                .apply(color: theme.colorScheme.surfaceContainerHigh),
          )
        ],
      ),
    );
  }
}

class TopCategories extends StatelessWidget {
  final List<PieChartData> data;
  final double totalValue;

  const TopCategories({
    super.key,
    required this.data,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (PieChartData pieChartData in data)
          Column(
            children: [
              TopCategoryListTile(
                  pieChartData: pieChartData, totalValue: totalValue),
              const SizedBox(height: 14)
            ],
          )
      ]),
    );
  }
}

class TopCategoryListTile extends StatelessWidget {
  final PieChartData pieChartData;
  final double totalValue;

  const TopCategoryListTile({
    super.key,
    required this.pieChartData,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.square_rounded, size: 18, color: pieChartData.color),
            const SizedBox(width: 4),
            Text(
              '${(pieChartData.value / totalValue * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(width: 6),
        Expanded(
            child: Text(pieChartData.name,
                style: theme.textTheme.labelMedium,
                softWrap: false,
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
