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
  final ValueNotifier<bool> updateNotifier = ValueNotifier(false);
  final int budgetId;

  BudgetOverviewPage({super.key, required this.budgetId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: updateNotifier,
        builder: (context, update, _) {
          final budget = BudgetController.getBudget(budgetId);

          final currency = Provider.of<AppData>(context).currency;
          final BudgetPeriod datePeriod =
              BudgetService.getPeriodByIndex(budget.budgetPeriodIndex);

          BudgetHistory currentBudgetHistory = BudgetHistory(
              targetValue: budget.targetValue,
              endValue: budget.currentValue,
              budgetPeriodIndex: budget.budgetPeriodIndex,
              startDate: budget.startDate,
              endDate: budget.resetDate);
          final ValueNotifier<BudgetHistory> budgetHistoryNotifier =
              ValueNotifier(currentBudgetHistory);

          var title = "${budget.category.target!.name} Budget";

          return Scaffold(
              appBar: BudgetronAppBar(
                  leading: const ArrowBackIconButton(),
                  actions: [
                    BudgetEditIcon(
                        budget: budget, updateNotifier: updateNotifier),
                    const SizedBox(width: 8),
                    const BudgetOptionsIcon(),
                  ],
                  title: title),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(children: [
                    BudgetHistoryOverview(
                        budget: budget,
                        budgetHistoryNotifier: budgetHistoryNotifier,
                        currentBudgetHistory: currentBudgetHistory),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                        valueListenable: budgetHistoryNotifier,
                        builder: (context, selectedHistory, _) {
                          return StreamBuilder(
                              stream: _getEntries([
                                selectedHistory.startDate,
                                selectedHistory.endDate
                              ], budget),
                              builder: (context, snapshot) {
                                List<Entry> entries = [];
                                if (snapshot.data?.isNotEmpty ?? false) {
                                  entries = snapshot.data!;
                                }

                                final value =
                                    EntryService.calculateTotalValue(entries);

                                return Expanded(
                                  child: Column(children: [
                                    BudgetProgressBar(
                                        history: selectedHistory,
                                        value: value,
                                        currency: currency),
                                    const SizedBox(height: 24),
                                    AmountOfEntries(
                                        amountOfEntries: entries.length),
                                    const SizedBox(height: 24),
                                    BudgetEntries(
                                        entries: entries,
                                        budgetPeriod: datePeriod)
                                  ]),
                                );
                              });
                        })
                  ])));
        });
  }

  Stream<List<Entry>> _getEntries(List<DateTime> period, Budget budget) {
    return EntryController.getEntries(
      period: period,
      categoryFilter: [budget.category.target!],
      budgetFilter: budget,
    );
  }
}

class BudgetHistoryOverview extends StatelessWidget {
  final ValueNotifier<BudgetHistory> budgetHistoryNotifier;
  final BudgetHistory currentBudgetHistory;
  final Budget budget;

  const BudgetHistoryOverview({
    super.key,
    required this.budget,
    required this.budgetHistoryNotifier,
    required this.currentBudgetHistory,
  });

  @override
  Widget build(BuildContext context) {
    var budgetHistoriesStream = BudgetController.getBudgetHistories(budget.id);

    return StreamBuilder(
        stream: budgetHistoriesStream,
        builder: (context, snapshot) {
          List<BudgetHistory> budgetHistories = [currentBudgetHistory];
          if (snapshot.data?.isNotEmpty ?? false) {
            budgetHistories.addAll(snapshot.data!);
          }

          return Container(
              height: 220,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                //NOTE 8 is width of separators, 6 is the amount of separators between 7 columns
                var columnWidth = (constraints.maxWidth - (8 * 6)) * (1 / 7);
                var isReverse = true;
                if (budgetHistories.length <= 7) {
                  isReverse = false;
                  budgetHistories = budgetHistories.reversed.toList();
                }

                return ListView.separated(
                    reverse: isReverse,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      var history = budgetHistories[index];

                      return BudgetHistoryColumn(
                        columnWidth: columnWidth,
                        history: history,
                        budgetHistoryNotifier: budgetHistoryNotifier,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 8);
                    },
                    itemCount: budgetHistories.length);
              }));
        });
  }
}

class BudgetHistoryColumn extends StatelessWidget {
  final ValueNotifier<BudgetHistory> budgetHistoryNotifier;
  final BudgetHistory history;

  final double columnWidth;

  const BudgetHistoryColumn({
    super.key,
    required this.history,
    required this.columnWidth,
    required this.budgetHistoryNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final endToTargetRatio = history.endValue / history.targetValue;
    final height = _resolveHeight(endToTargetRatio);
    final isOverspent = endToTargetRatio > 1.0;

    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => budgetHistoryNotifier.value = history,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
            Container(
              width: columnWidth,
              height: 140,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
            ),
            ValueListenableBuilder(
                valueListenable: budgetHistoryNotifier,
                builder: (context, selectedHistory, _) {
                  final isSelected = history == selectedHistory;
                  final color = isSelected
                      ? (isOverspent
                          ? colorScheme.error
                          : colorScheme.secondary)
                      : colorScheme.primary;
                  final textColor = colorScheme.primary;

                  return Container(
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      width: columnWidth,
                      height: height,
                      child: Center(
                          child: isSelected
                              ? Text(
                                  "${(endToTargetRatio * 100).toStringAsFixed(0)}%",
                                  style: BudgetronFonts.nunitoSize12Weight400
                                      .apply(color: textColor))
                              : const SizedBox()));
                })
          ])),
    );
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
  final BudgetHistory history;
  final double value;
  final String currency;

  const BudgetProgressBar({
    super.key,
    required this.history,
    required this.value,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final targetValue = history.targetValue;

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          ListTileWithProgressBar(
            leading: _getLeading(value),
            trailing: _getTrailing(targetValue),
            currentValue: value,
            totalValue: targetValue,
          ),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_formatDate(history.startDate),
                style: BudgetronFonts.nunitoSize12Weight400),
            Text(_formatDate(history.endDate),
                style: BudgetronFonts.nunitoSize12Weight400)
          ])
        ]));
  }

  Widget _getLeading(double value) {
    return Row(children: [
      Text(value.toStringAsFixed(2),
          style: BudgetronFonts.nunitoSize16Weight400),
      const SizedBox(width: 2),
      Text(currency, style: BudgetronFonts.nunitoSize12Weight400),
    ]);
  }

  Widget _getTrailing(double value) {
    return Row(children: [
      Text(value.toStringAsFixed(0),
          style: BudgetronFonts.nunitoSize16Weight400Gray),
      const SizedBox(width: 2),
      Text(currency, style: BudgetronFonts.nunitoSize12Weight400Gray),
    ]);
  }

  String _formatDate(DateTime startDate) {
    return "${DateFormat.MMMd().format(startDate)}, ${DateFormat.y().format(startDate)}";
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

class BudgetOptionsIcon extends StatelessWidget {
  const BudgetOptionsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        onTap: () => {},
        icon: Icon(Icons.more_vert,
            color: Theme.of(context).colorScheme.primary));
  }
}

class BudgetEditIcon extends StatelessWidget {
  final ValueNotifier<bool> updateNotifier;
  final Budget budget;

  const BudgetEditIcon(
      {super.key, required this.budget, required this.updateNotifier});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        onTap: () => showDialog(
            context: context,
            builder: (context) => EditBudgetDialog(
                budget: budget, updateNotifier: updateNotifier)),
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
