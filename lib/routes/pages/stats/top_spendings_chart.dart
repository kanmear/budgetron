import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/classes/data_visualization/elements/pie_chart.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/enums/date_period.dart';

class TopSpendingsChart extends StatelessWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier;

  const TopSpendingsChart({super.key, required this.datePeriodNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: datePeriodNotifier,
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
                          color: Theme.of(context).colorScheme.surface),
                      padding: const EdgeInsets.only(
                          top: 12, left: 10, right: 10, bottom: 12),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Top spendings',
                                  style: BudgetronFonts.nunitoSize16Weight400)),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              BudgetronPieChart(
                                  data: data,
                                  child: _formChild(
                                      totalValue, totalValueOfTopSpendings)),
                              const SizedBox(width: 20),
                              TopCategories(data: data, totalValue: totalValue)
                            ],
                          ),
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
        });
  }

  _getEntries() {
    DateTime now = DateTime.now();
    if (datePeriodNotifier.value == DatePeriod.month) {
      return EntryController.getEntries(
          isExpense: true,
          period: [DateTime(now.year, now.month), DateTime.now()]);
    } else {
      return EntryController.getEntries(
          isExpense: true, period: [DateTime(now.year), DateTime.now()]);
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

    List<PieChartData> values = data.values.toList();
    values.sort((a, b) => b.value.compareTo(a.value));
    if (values.length > 4) {
      values = values.sublist(0, 4);
    }

    return values;
  }

  Widget _formChild(double totalValue, double totalValueOfTopSpendings) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            totalValueOfTopSpendings.toStringAsFixed(2),
            style: BudgetronFonts.nunitoSize22Weight500,
          ),
          Text(
            'of ${totalValue.toStringAsFixed(2)}',
            style: BudgetronFonts.nunitoSize14Weight400Gray,
          ),
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
    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.square_rounded, size: 18, color: pieChartData.color),
            const SizedBox(width: 4),
            Text(
              '${(pieChartData.value / totalValue * 100).toStringAsFixed(0)}%',
              style: BudgetronFonts.nunitoSize14Weight600,
            )
          ],
        ),
        const SizedBox(width: 6),
        Expanded(
            child: Text(pieChartData.name,
                style: BudgetronFonts.nunitoSize11Weight300,
                softWrap: false,
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
