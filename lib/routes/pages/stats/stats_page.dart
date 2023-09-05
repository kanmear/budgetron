import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';
import 'package:budgetron/ui/classes/data_visualization/elements/pie_chart.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/icons.dart';
import 'package:budgetron/ui/fonts.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: const [
            BudgetronAppBarWithTitle(
                title: 'Statistics', leftIconButton: MenuIconButton()),
            OverallChart()
          ],
        ));
  }
}

class OverallChart extends StatelessWidget {
  const OverallChart({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Entry>>(
        stream: _getEntries(),
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            List<Entry> entries = snapshot.data!;
            double totalValue = EntryService.calculateTotalValue(entries);
            Map<int, PieChartData> data = _getData(entries);

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
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Overall',
                            style: BudgetronFonts.nunitoSize16Weight400)),
                    const SizedBox(height: 9),
                    BudgetronPieChart(
                      data: _getData(entries),
                      child: _formChild(totalValue),
                    ),
                    const SizedBox(height: 2),
                    TopThreeCategories(
                        data: data.values.toList(), total: totalValue)
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
  }

  Stream<List<Entry>> _getEntries() {
    return EntryController.getEntries(
        period: [DateTime(2023, 7, 1), DateTime(2023, 7, 30)]);
  }

  Map<int, PieChartData> _getData(List<Object> entries) {
    Map<int, PieChartData> data = {};
    for (Entry entry in entries as List<Entry>) {
      EntryCategory category = entry.category.target!;
      int categoryId = category.id;
      if (data.containsKey(categoryId)) {
        data[categoryId] = PieChartData(
            color: CategoryService.stringToColor(category.color),
            value: entry.value + data[categoryId]!.value,
            name: category.name);
      } else {
        data.addAll({
          categoryId: PieChartData(
              color: CategoryService.stringToColor(category.color),
              value: entry.value,
              name: category.name)
        });
      }
    }

    return data;
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

class TopThreeCategories extends StatelessWidget {
  final List<PieChartData> data;
  final double total;

  const TopThreeCategories(
      {super.key, required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    List<PieChartData> topCategories = data;
    topCategories.sort((a, b) => a.value.compareTo(b.value));
    topCategories = topCategories.sublist(0, 3);

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
    double value = data.value * -1;

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
