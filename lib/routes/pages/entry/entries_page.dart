import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/date_selector.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/list_tiles/list_tile.dart';
import 'package:budgetron/ui/classes/date_selector_legacy.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/routes/pages/entry/edit_entry_page.dart';

//TODO check if stateful widget is not needed
class EntriesPage extends StatefulWidget {
  //TODO make settings entry for default datePeriod
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.day);
  final ValueNotifier<List<DateTime>> dateTimeNotifier =
      ValueNotifier(BudgetronDateUtils.getDatesInPeriod(BudgetronPage.entries));

  EntriesPage({
    super.key,
  });

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final isLegacy = appData.legacyDateSelector;
    final theme = Theme.of(context);

    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Column(children: [
          EntriesListView(
              dateTimeNotifier: widget.dateTimeNotifier,
              datePeriodNotifier: widget.datePeriodNotifier,
              currency: currency,
              isLegacy: isLegacy,
              theme: theme),
          _resolveDateSelector(isLegacy, appData.earliestEntryDate)
        ]));
  }

  Widget _resolveDateSelector(bool legacyDateSelector, DateTime earliestDate) {
    if (legacyDateSelector) {
      return LegacyDateSelector(datePeriodNotifier: widget.datePeriodNotifier);
    } else {
      return DateSelector(
        datePeriodNotifier: widget.datePeriodNotifier,
        dateTimeNotifier: widget.dateTimeNotifier,
        earliestDate: earliestDate,
        periodItems: const [DatePeriod.day, DatePeriod.month, DatePeriod.year],
      );
    }
  }
}

class EntriesListView extends StatelessWidget {
  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final String currency;
  final bool isLegacy;
  final ThemeData theme;

  const EntriesListView(
      {super.key,
      required this.dateTimeNotifier,
      required this.currency,
      required this.datePeriodNotifier,
      required this.isLegacy,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return _resolveBody(isLegacy);
  }

  Widget _resolveBody(bool isLegacy) {
    if (isLegacy) {
      return Flexible(
          child: StreamBuilder<List<Entry>>(
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
    } else {
      return Flexible(
          child: ValueListenableBuilder(
              valueListenable: dateTimeNotifier,
              builder: (context, value, child) {
                return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: StreamBuilder<List<Entry>>(
                        stream: _getEntries(),
                        builder: (context, snapshot) {
                          if (snapshot.data?.isNotEmpty ?? false) {
                            return _buildListView(snapshot.data!, currency);
                          } else {
                            return Center(
                                child: Text(
                              'No entries for this period',
                              style: theme.textTheme.bodyMedium!.apply(
                                  color:
                                      theme.colorScheme.surfaceContainerHigh),
                            ));
                          }
                        }));
              }));
    }
  }

  Stream<List<Entry>> _getEntries() {
    var fromDate = dateTimeNotifier.value[0];
    var toDate = dateTimeNotifier.value[1];

    return EntryController.getEntries(period: [fromDate, toDate]);
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
                  EntryListTile(
                      category: category,
                      entries: entriesToCategoryMap[category]!,
                      isExpandable: datePeriod == DatePeriod.day,
                      datePeriod: datePeriod,
                      theme: theme),
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

class EntryListTile extends StatelessWidget {
  final ValueNotifier<bool> isExpandedListenable = ValueNotifier(false);
  final DatePeriod datePeriod;
  final EntryCategory category;
  final List<Entry> entries;
  final bool isExpandable;
  final ThemeData theme;

  EntryListTile({
    super.key,
    required this.entries,
    required this.category,
    required this.isExpandable,
    required this.datePeriod,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isExpandedListenable,
      builder: (context, value, child) {
        return Column(
          children: [
            _resolveWrapperWidget(
              context,
              CustomEntryListTile(
                leadingIcon: _getLeadingIcon(),
                leadingString: category.name,
                leadingOption: _getLeadingOption(),
                trailingString: _resolveSum(),
              ),
            ),
            _expandedView(context),
            //REFACTOR replace with listview.separated
            const SizedBox(height: 8)
          ],
        );
      },
    );
  }

  _resolveWrapperWidget(BuildContext context, Widget child) {
    if (datePeriod != DatePeriod.day) {
      return SizedBox(child: child);
    }

    return InkWell(
        onTap: (isExpandable && entries.length > 1)
            ? () => _toggleExpandedView()
            : () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    EditEntryPage(entry: entries.first)),
        child: child);
  }

  _getLeadingIcon() => Icon(
        Icons.square_rounded,
        size: 18,
        color: CategoryService.stringToColor(category.color),
      );

  _getLeadingOption() => isExpandable && entries.length > 1
      ? Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary)
      : const SizedBox();

  _toggleExpandedView() =>
      isExpandedListenable.value = !isExpandedListenable.value;

  _resolveSum() {
    return entries
        .map((entry) => entry.value)
        .reduce((value, element) => value + element)
        .toStringAsFixed(2);
  }

  _expandedView(BuildContext context) {
    if (isExpandedListenable.value && entries.length > 1) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: theme.colorScheme.surfaceContainerLowest),
          padding: const EdgeInsets.only(left: 8, right: 10, bottom: 8),
          //APPROACH is there a better way to handle 'RenderBox was not laid out'?
          //HACK height value is take from design
          height: 76,
          child: ListView.separated(
            itemCount: entries.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) =>
                ExpandedEntryTile(entry: entries[index], theme: theme),
          ));
    } else {
      return const SizedBox();
    }
  }
}

class ExpandedEntryTile extends StatelessWidget {
  final Entry entry;
  final ThemeData theme;

  const ExpandedEntryTile({
    super.key,
    required this.entry,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => EditEntryPage(entry: entry)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat.Hm().format(entry.dateTime),
                style: theme.textTheme.labelMedium!
                    .apply(color: theme.colorScheme.surfaceContainerHigh),
                textAlign: TextAlign.center),
            Text(entry.value.toStringAsFixed(2),
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
