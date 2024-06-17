import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/date_selector_groups.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/routes/popups/group/edit_group_popup.dart';
import 'package:budgetron/routes/pages/group/widgets/group_overview_chart.dart';

class GroupOverviewPage extends StatelessWidget {
  GroupOverviewPage({super.key, required this.groupId});

  final int groupId;
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.month);
  final ValueNotifier<List<DateTime>> dateTimeNotifier =
      ValueNotifier(BudgetronDateUtils.calculatePairOfDates());
  final ValueNotifier<bool> expenseFilterNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> groupChangeNotifier = ValueNotifier(false);

    return ValueListenableBuilder(
      valueListenable: groupChangeNotifier,
      builder: (context, value, _) {
        CategoryGroup group = GroupsController.getGroup(groupId);

        var title = "${group.name} Group";
        var entriesStream = EntryController.getEntries(
            categoryFilter: [...group.categories.toList()]);

        return Scaffold(
            appBar: BudgetronAppBar(
                leading: const ArrowBackIconButton(),
                actions: [
                  EditGroupIcon(
                      group: group,
                      onGroupUpdate: () => _updateGroup(groupChangeNotifier))
                ],
                title: title),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: StreamBuilder<List<Entry>>(
                stream: entriesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Entry>> snapshot) {
                  List<Entry> entries = [];
                  var isEitherOr = false;
                  var earliestDate = DateTime.now();
                  if (snapshot.data?.isNotEmpty ?? false) {
                    //NOTE/HACK looks like if these variables are changed outside of
                    //this body, they are not picked up correctly in widgets under
                    entries = snapshot.data!;
                    isEitherOr = _resolveIfOnlyOneType(entries);
                    earliestDate = _getEarliestDate(entries);
                  }

                  return Column(children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: AnimatedBuilder(
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
                                  //REFACTOR right now each widget below splits
                                  //entries into groups by itself, which triples
                                  //the amount of work; this should be fixed

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
                                }))),
                    DateSelectorGroups(
                        datePeriodNotifier: datePeriodNotifier,
                        dateTimeNotifier: dateTimeNotifier,
                        periodItems: const [DatePeriod.month, DatePeriod.year],
                        earliestDate: earliestDate)
                  ]);
                }));
      },
    );
  }

  bool _resolveIfOnlyOneType(List<Entry> entries) {
    var isExpense = entries.first.category.target!.isExpense;
    return !entries
        .any((entry) => entry.category.target!.isExpense != isExpense);
  }

  DateTime _getEarliestDate(List<Entry> entries) {
    return entries
        .reduce((value, element) =>
            value.dateTime.isBefore(element.dateTime) ? value : element)
        .dateTime;
  }

  void _updateGroup(ValueNotifier<bool> groupChangeNotifier) =>
      groupChangeNotifier.value = !groupChangeNotifier.value;
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
  const EditGroupIcon(
      {super.key, required this.group, required this.onGroupUpdate});

  final CategoryGroup group;
  final Function onGroupUpdate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) =>
              EditGroupDialog(group: group, onGroupUpdate: onGroupUpdate)),
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
