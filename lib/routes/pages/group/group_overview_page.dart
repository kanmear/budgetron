import 'package:budgetron/routes/popups/group/edit_group_popup.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/ui/classes/date_selector_stats.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/routes/pages/group/widgets/group_overview_chart.dart';

//REFACTOR tons of glaring issues
class GroupOverviewPage extends StatelessWidget {
  GroupOverviewPage({super.key, required this.group});

  final CategoryGroup group;
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.month);
  final ValueNotifier<List<DateTime>> dateTimeNotifier =
      ValueNotifier(_calculateDates());
  final ValueNotifier<bool> expenseFilterNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    var title = "${group.name} Group";
    var entriesStream = EntryController.getEntries(
        categoryFilter: [...group.categories.toList()]);

    return Scaffold(
        appBar: BudgetronAppBar(
            leading: const ArrowBackIconButton(),
            actions: [EditGroupIcon(group: group)],
            title: title),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: StreamBuilder<List<Entry>>(
                      stream: entriesStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Entry>> snapshot) {
                        List<Entry> entries = [];
                        var isEitherOr = false;
                        if (snapshot.data?.isNotEmpty ?? false) {
                          //NOTE does this body work in async?
                          entries = snapshot.data!;
                          isEitherOr = _resolveIfOnlyOneType(entries);
                        }

                        return AnimatedBuilder(
                            animation: Listenable.merge([
                              datePeriodNotifier,
                              dateTimeNotifier,
                              expenseFilterNotifier
                            ]),
                            builder: (BuildContext context, Widget? child) {
                              var dates = dateTimeNotifier.value;
                              var modifiedEntries =
                                  EntryService.selectEntriesBetween(
                                      entries, dates.first, dates.last);

                              return Column(children: [
                                GroupOverviewChart(
                                    entries: modifiedEntries,
                                    isEitherOr: isEitherOr,
                                    isExpenseFilterNotifier:
                                        expenseFilterNotifier),
                                const SizedBox(height: 24),
                                GroupAmountOfEntries(
                                    entries: modifiedEntries,
                                    isEitherOr: isEitherOr,
                                    isExpense: expenseFilterNotifier.value),
                                const SizedBox(height: 24),
                                GroupEntries(
                                    entries: modifiedEntries,
                                    datePeriod: datePeriodNotifier.value,
                                    isEitherOr: isEitherOr,
                                    isExpense: expenseFilterNotifier.value)
                              ]);
                            });
                      }))),
          DateSelectorStats(
              datePeriodNotifier: datePeriodNotifier,
              dateTimeNotifier: dateTimeNotifier,
              periodItems: const [DatePeriod.month, DatePeriod.year])
        ]));
  }

  static List<DateTime> _calculateDates() {
    //TODO should account for date period; add after implementing Settings
    var now = DateTime.now();
    var endDate = BudgetronDateUtils.shiftToEndOfMonth(now);

    return [DateTime(now.year, now.month), endDate];
  }

  bool _resolveIfOnlyOneType(List<Entry> entries) {
    var isExpense = entries.first.category.target!.isExpense;
    return !entries
        .any((entry) => entry.category.target!.isExpense != isExpense);
  }
}

class GroupAmountOfEntries extends StatelessWidget {
  const GroupAmountOfEntries(
      {super.key,
      required this.entries,
      required this.isEitherOr,
      required this.isExpense});

  final List<Entry> entries;
  final bool isEitherOr;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    var length = isEitherOr
        ? entries.length
        : entries
            .where((entry) => entry.category.target!.isExpense == isExpense)
            .length;

    return Center(
        child: Text("$length entries",
            style: BudgetronFonts.nunitoSize16Weight400Gray));
  }
}

class GroupEntries extends StatelessWidget {
  const GroupEntries(
      {super.key,
      required this.entries,
      required this.datePeriod,
      required this.isEitherOr,
      required this.isExpense});

  final DatePeriod datePeriod;
  final List<Entry> entries;
  final bool isEitherOr;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<AppData>(context).currency;

    var selectedEntries = entries;
    if (!isEitherOr) {
      selectedEntries = entries
          .where((entry) => entry.category.target!.isExpense == isExpense)
          .toList();
    }

    Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap = {};
    List<DateTime> entryDates = [];

    var dateGroupPeriod =
        datePeriod == DatePeriod.month ? DatePeriod.day : DatePeriod.month;

    EntryService.formEntriesData(
        dateGroupPeriod, selectedEntries, entriesMap, entryDates);

    return Expanded(
        child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: entryDates.length,
            itemBuilder: (context, index) {
              var groupingDate = entryDates[index];

              return EntryListTileContainer(
                  entriesToCategoryMap: entriesMap[groupingDate]!,
                  groupingDate: groupingDate,
                  datePeriod: dateGroupPeriod,
                  currency: currency);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Column(children: [
                SizedBox(height: 16),
                HorizontalSeparator(),
                SizedBox(height: 16)
              ]);
            }));
  }
}

class EditGroupIcon extends StatelessWidget {
  const EditGroupIcon({super.key, required this.group});

  final CategoryGroup group;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) => EditGroupDialog(group: group)),
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
