import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/models/budget/budget_history.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/routes/popups/budget/edit_budget_popup.dart';
import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';

class BudgetOverviewPage extends StatelessWidget {
  const BudgetOverviewPage({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppData>(context).currency;
    final BudgetPeriod datePeriod =
        BudgetService.getPeriodByIndex(budget.budgetPeriodIndex);

    var title = "${budget.category.target!.name} Budget";
    var entriesStream = EntryController.getEntries(
        ids: budget.entriesIDs, categoryFilter: [budget.category.target!]);

    return Scaffold(
        appBar: BudgetronAppBar(
            leading: const ArrowBackIconButton(),
            actions: [
              EditBudgetIcon(budget: budget),
              const SizedBox(width: 8),
              const BudgetMenuIcon()
            ],
            title: title),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: StreamBuilder<List<Entry>>(
                stream: entriesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Entry>> snapshot) {
                  List<Entry> entries = [];
                  if (snapshot.data?.isNotEmpty ?? false) {
                    entries = snapshot.data!;
                  }

                  return Column(children: [
                    BudgetHistoryOverview(budget: budget),
                    const SizedBox(height: 8),
                    BudgetProgressBar(budget: budget, currency: currency),
                    const SizedBox(height: 24),
                    AmountOfEntries(amountOfEntries: entries.length),
                    const SizedBox(height: 24),
                    BudgetEntries(entries: entries, budgetPeriod: datePeriod)
                  ]);
                })));
  }
}

class BudgetHistoryOverview extends StatelessWidget {
  const BudgetHistoryOverview({
    super.key,
    required this.budget,
  });

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    var budgetHistoriesStream = BudgetController.getBudgetHistories(budget.id);
    BudgetHistory currentBudgetHistory = BudgetHistory(
        targetValue: budget.targetValue,
        endValue: budget.currentValue,
        budgetPeriodIndex: budget.budgetPeriodIndex,
        endDate: DateTime.now());

    return StreamBuilder(
        stream: budgetHistoriesStream,
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            List<BudgetHistory> budgetHistories = [currentBudgetHistory];
            budgetHistories.addAll(snapshot.data!);

            return CustomPaint(
                foregroundPainter: LinePainter(),
                child: Container(
                    height: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      //NOTE 8 is width of separators, 6 is the amount of separators between 7 columns
                      var columnWidth =
                          (constraints.maxWidth - (8 * 6)) * (1 / 7);
                      var isReverse = true;
                      if (budgetHistories.length <= 7) {
                        isReverse = false;
                        budgetHistories = budgetHistories.reversed.toList();
                      }

                      return ListView.separated(
                          reverse: isReverse,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return BudgetHistoryColumn(
                                width: columnWidth,
                                history: budgetHistories[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 8);
                          },
                          itemCount: budgetHistories.length);
                    })));
          } else {
            return Center(
                child: Text('No histories in database',
                    style: BudgetronFonts.nunitoSize16Weight300Gray));
          }
        });
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double padding = 12;
    const double column100percentHeight = 140;
    const double lineHeight = column100percentHeight + padding;

    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(padding, size.height - lineHeight),
        Offset(size.width - padding, size.height - lineHeight), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BudgetHistoryColumn extends StatelessWidget {
  const BudgetHistoryColumn(
      {super.key, required this.history, required this.width});

  final BudgetHistory history;
  final double width;

  @override
  Widget build(BuildContext context) {
    var endPercentage = (history.endValue / history.targetValue);
    var height = _resolveHeight(endPercentage);

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            width: width,
            height: height,
            child: Center(
                child: Text("${(endPercentage * 100).toStringAsFixed(0)}%",
                    style: BudgetronFonts.nunitoSize12Weight400Gray))));
  }

  double _resolveHeight(double endPercentage) {
    //NOTE 140 is 100%
    double maxHeight = (220 - (12 * 2));
    double minHeight = 25;
    var height = endPercentage * 140;
    if (height < minHeight) {
      return minHeight;
    } else if (height > maxHeight) {
      return maxHeight;
    }
    return height;
  }
}

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar(
      {super.key, required this.budget, required this.currency});

  final Budget budget;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final budgetPeriod =
        BudgetService.getPeriodByIndex(budget.budgetPeriodIndex);
    final now = DateTime.now();

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTileWithProgressBar(
              leading: _getLeading(budget),
              trailing: _getTrailing(budget),
              currentValue: budget.currentValue,
              totalValue: budget.targetValue,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_resolveLeftString(budgetPeriod, now),
                    style: BudgetronFonts.nunitoSize12Weight400),
                Text(_resolveRightString(budgetPeriod, now),
                    style: BudgetronFonts.nunitoSize12Weight400)
              ],
            )
          ],
        ));
  }

  Widget _getLeading(Budget budget) {
    return Row(children: [
      Text(budget.currentValue.toStringAsFixed(2),
          style: BudgetronFonts.nunitoSize16Weight400),
      const SizedBox(width: 2),
      Text(currency, style: BudgetronFonts.nunitoSize12Weight400),
    ]);
  }

  Widget _getTrailing(Budget budget) {
    return Row(children: [
      Text(budget.targetValue.toStringAsFixed(0),
          style: BudgetronFonts.nunitoSize16Weight400Gray),
      const SizedBox(width: 2),
      Text(currency, style: BudgetronFonts.nunitoSize12Weight400Gray),
    ]);
  }

  String _resolveLeftString(BudgetPeriod budgetPeriod, DateTime now) {
    if (budgetPeriod == BudgetPeriod.month) {
      return "${DateFormat.MMM().format(now)}, ${DateFormat.y().format(now)}";
    } else {
      // year period
      return DateFormat.y().format(now);
    }
  }

  String _resolveRightString(BudgetPeriod budgetPeriod, DateTime now) {
    if (budgetPeriod == BudgetPeriod.month) {
      return "${DateFormat.MMM().format(budget.resetDate)}, "
          "${DateFormat.y().format(budget.resetDate)}";
    } else {
      // year period
      return DateFormat.y().format(budget.resetDate);
    }
  }
}

class AmountOfEntries extends StatelessWidget {
  const AmountOfEntries({super.key, required this.amountOfEntries});

  final int amountOfEntries;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("$amountOfEntries entries",
            style: BudgetronFonts.nunitoSize16Weight400Gray));
  }
}

//TODO should these Entries be editable? this would require Month period rework
class BudgetEntries extends StatelessWidget {
  const BudgetEntries(
      {super.key, required this.entries, required this.budgetPeriod});

  final BudgetPeriod budgetPeriod;
  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    //REFACTOR copy paste of _buildListView from entries_page.dart
    Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap = {};
    List<DateTime> entryDates = [];
    var currency = Provider.of<AppData>(context).currency;

    var datePeriod =
        DatePeriod.values.firstWhere((e) => e.name == budgetPeriod.name);
    EntryService.formEntriesData(datePeriod, entries, entriesMap, entryDates);

    return Flexible(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: entryDates.length,
        itemBuilder: (context, index) {
          var groupingDate = entryDates[index];

          return EntryListTileContainer(
              entriesToCategoryMap: entriesMap[groupingDate]!,
              groupingDate: groupingDate,
              datePeriod: datePeriod,
              currency: currency);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Column(
            children: [
              SizedBox(height: 16),
              HorizontalSeparator(),
              SizedBox(height: 16)
            ],
          );
        },
      ),
    );
  }
}

//TODO if changes are made, Overview should be reloaded with a new Budget
//maybe pass a callback that gets called when Save is pressed
class EditBudgetIcon extends StatelessWidget {
  const EditBudgetIcon({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) => EditBudgetDialog(budget: budget)),
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}

class BudgetMenuIcon extends StatelessWidget {
  const BudgetMenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {},
      icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
