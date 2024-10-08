import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/app_data.dart';

import 'package:budgetron/db/entry_controller.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/models/category/category.dart';

import 'package:budgetron/routes/pages/entry/widgets/entry_list_tile.dart';
import 'package:budgetron/routes/pages/entry/entries_page/legacy_entries_page.dart';

import 'package:budgetron/ui/classes/date_selector.dart';

import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/utils/date_utils.dart';

class EntriesPage extends StatelessWidget {
  //TODO make settings entry for default datePeriod
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.day);
  final ValueNotifier<List<DateTime>> dateTimeNotifier = ValueNotifier(
      BudgetronDateUtils.calculateDateRange(BudgetronPage.entries));

  EntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    if (appData.legacyDateSelector) {
      return LegacyEntriesPage();
    }

    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Column(children: [
          EntriesListView(
            dateTimeNotifier: dateTimeNotifier,
            datePeriodNotifier: datePeriodNotifier,
          ),
          DateSelector(
            datePeriodNotifier: datePeriodNotifier,
            dateTimeNotifier: dateTimeNotifier,
            earliestDate: appData.earliestEntryDate,
            periodItems: const [
              DatePeriod.day,
              DatePeriod.month,
              DatePeriod.year
            ],
          )
        ]));
  }
}

class EntriesListView extends StatelessWidget {
  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;

  const EntriesListView({
    super.key,
    required this.dateTimeNotifier,
    required this.datePeriodNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Flexible(
        child: ValueListenableBuilder(
            valueListenable: dateTimeNotifier,
            builder: (context, value, child) {
              return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: StreamBuilder<List<Entry>>(
                      stream: _getEntriesStream(),
                      builder: (context, snapshot) {
                        if (snapshot.data?.isNotEmpty ?? false) {
                          return EntryListTileContainer(
                            entries: snapshot.data!,
                            datePeriod: datePeriodNotifier.value,
                          );
                        } else {
                          return Center(
                              child: Text(
                            'No entries for this period',
                            style: theme.textTheme.bodyMedium!.apply(
                                color: theme.colorScheme.surfaceContainerHigh),
                          ));
                        }
                      }));
            }));
  }

  _getEntriesStream() {
    final fromDate = dateTimeNotifier.value[0];
    final toDate = dateTimeNotifier.value[1];

    //REFACTOR should not directly call controllers
    return EntryController.getEntries(period: [fromDate, toDate]);
  }
}

class EntryListTileContainer extends StatelessWidget {
  final List<Entry> entries;
  final DatePeriod datePeriod;

  const EntryListTileContainer({
    super.key,
    required this.entries,
    required this.datePeriod,
  });

  @override
  Widget build(BuildContext context) {
    Map<EntryCategory, List<Entry>> categoryToEntriesMap =
        _calculateMap(entries);
    final isExpandable = datePeriod == DatePeriod.day;

    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);
    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _resolveContainerTitle(datePeriod, entries.first.dateTime, theme),
              _resolveContainerSum(entries, currency, theme)
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: categoryToEntriesMap.keys.length,
              itemBuilder: (context, index) {
                final category = categoryToEntriesMap.keys.elementAt(index);

                return EntryListTile(
                    entries: categoryToEntriesMap[category]!,
                    category: category,
                    isExpandable: isExpandable,
                    datePeriod: datePeriod,
                    theme: theme);
              },
              separatorBuilder: (context, _) {
                return const SizedBox(height: 8);
              },
            ),
          ),
        ],
      ),
    );
  }

  _calculateMap(List<Entry> entries) {
    Map<EntryCategory, List<Entry>> map = {};

    for (var entry in entries) {
      var category = entry.category.target!;
      if (map.containsKey(category)) {
        map[category]!.add(entry);
      } else {
        map[category] = [entry];
      }
    }

    return map;
  }

  Widget _resolveContainerTitle(
      DatePeriod datePeriod, DateTime groupingDate, ThemeData theme) {
    //if grouped by day and containers date is today => display today
    DateTime now = DateTime.now();

    if (datePeriod == DatePeriod.day &&
        BudgetronDateUtils.stripTime(groupingDate) ==
            DateTime(now.year, now.month, now.day)) {
      return Text('Today', style: theme.textTheme.bodySmall);
    }

    String text;
    switch (datePeriod) {
      case DatePeriod.day:
        text = DateFormat.yMMMd().format(groupingDate);
        break;
      case DatePeriod.week:
        text = DateFormat.yMMMd().format(groupingDate);
        break;
      case DatePeriod.month:
        text = DateFormat.yMMM().format(groupingDate);
        break;
      case DatePeriod.year:
        text = DateFormat.y().format(groupingDate);
        break;
      default:
        throw Exception('Not a valid date period.');
    }

    return Text(text, style: theme.textTheme.bodySmall);
  }

  Widget _resolveContainerSum(
      List<Entry> entries, String currency, ThemeData theme) {
    final sum = entries
        .map((e) => e.value)
        .reduce((value, element) => value + element)
        .toStringAsFixed(2);

    return Text(
      "$sum $currency",
      style: theme.textTheme.bodySmall,
    );
  }
}
