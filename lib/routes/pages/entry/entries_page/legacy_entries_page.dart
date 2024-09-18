import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/app_data.dart';

import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/logic/entry/entry_service.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/models/category/category.dart';

import 'package:budgetron/ui/classes/date_selector_legacy.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';

import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/utils/date_utils.dart';

import 'package:budgetron/routes/pages/entry/entries_page.dart';

class LegacyEntriesPage extends StatelessWidget {
  //TODO make settings entry for default datePeriod
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.day);
  final ValueNotifier<List<DateTime>> dateTimeNotifier = ValueNotifier(
      BudgetronDateUtils.calculateDateRange(BudgetronPage.entries));

  LegacyEntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Column(children: [
          EntriesListView(
              dateTimeNotifier: dateTimeNotifier,
              datePeriodNotifier: datePeriodNotifier,
              currency: currency,
              theme: theme),
          LegacyDateSelector(datePeriodNotifier: datePeriodNotifier)
        ]));
  }
}

class EntriesListView extends StatelessWidget {
  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final String currency;
  final ThemeData theme;

  const EntriesListView(
      {super.key,
      required this.dateTimeNotifier,
      required this.currency,
      required this.datePeriodNotifier,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: StreamBuilder<List<Entry>>(
            //REFACTOR should not directly call controllers
            stream: EntryController.getEntries(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return ValueListenableBuilder(
                    valueListenable: datePeriodNotifier,
                    builder: (context, value, child) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: _buildListView(snapshot.data!, currency));
                    });
              } else {
                return Center(
                    child: Text(
                  'No entries in database',
                  style: theme.textTheme.bodyMedium!
                      .apply(color: theme.colorScheme.surfaceContainerHigh),
                ));
              }
            }));
  }

  Widget _buildListView(List<Entry> entries, String currency) {
    Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap = {};
    List<DateTime> entryDates = [];

    DatePeriod datePeriod = datePeriodNotifier.value;

    EntryService.formEntriesData(datePeriod, entries, entriesMap, entryDates);

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: entryDates.length,
      itemBuilder: (context, index) {
        var groupingDate = entryDates[index];

        return EntryListTileContainer(
            entriesToCategoryMap: entriesMap[groupingDate]!,
            groupingDate: groupingDate,
            datePeriod: datePeriod,
            currency: currency,
            theme: theme);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              SizedBox(height: 16),
              HorizontalSeparator(),
              SizedBox(height: 16)
            ],
          ),
        );
      },
    );
  }
}

class EntryListTileContainer extends StatelessWidget {
  final Map<EntryCategory, List<Entry>> entriesToCategoryMap;
  final DatePeriod datePeriod;
  final String currency;
  final DateTime groupingDate;
  final ThemeData theme;

  const EntryListTileContainer({
    super.key,
    required this.entriesToCategoryMap,
    required this.groupingDate,
    required this.datePeriod,
    required this.currency,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _resolveContainerTitle(),
                  _resolveContainerSumValue(entriesToCategoryMap)
                ],
              ),
              const SizedBox(height: 8),
              Column(children: [
                for (var category in entriesToCategoryMap.keys)
                  Column(
                    children: [
                      EntryListTile(
                          category: category,
                          entries: entriesToCategoryMap[category]!,
                          isExpandable: datePeriod == DatePeriod.day,
                          datePeriod: datePeriod,
                          theme: theme),
                      const SizedBox(height: 8),
                    ],
                  ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resolveContainerTitle() {
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

  Widget _resolveContainerSumValue(Map<EntryCategory, List<Entry>> entries) {
    var sum = entries.values
        .expand((element) => element.toList())
        .map((e) => e.value)
        .reduce((value, element) => value + element)
        .toStringAsFixed(2);

    return Text(
      "$sum $currency",
      style: theme.textTheme.bodySmall,
    );
  }
}
