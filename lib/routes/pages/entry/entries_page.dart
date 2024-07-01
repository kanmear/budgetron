import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/date_selector.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
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

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          EntriesListView(
              dateTimeNotifier: widget.dateTimeNotifier,
              datePeriodNotifier: widget.datePeriodNotifier,
              currency: appData.currency,
              isLegacy: isLegacy),
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

  const EntriesListView(
      {super.key,
      required this.dateTimeNotifier,
      required this.currency,
      required this.datePeriodNotifier,
      required this.isLegacy});

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
                    style: BudgetronFonts.nunitoSize16Weight300Gray,
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
                              style: BudgetronFonts.nunitoSize16Weight300Gray,
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
            currency: currency);
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

  const EntryListTileContainer({
    super.key,
    required this.entriesToCategoryMap,
    required this.groupingDate,
    required this.datePeriod,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _resolveContainerTitle(),
                    _resolveContainerSumValue(entriesToCategoryMap)
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(children: [
                for (var category in entriesToCategoryMap.keys)
                  EntryListTile(
                    category: category,
                    entries: entriesToCategoryMap[category]!,
                    isExpandable: datePeriod == DatePeriod.day,
                    datePeriod: datePeriod,
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
      return Text(
        "Today",
        style: BudgetronFonts.nunitoSize16Weight600,
      );
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

    return Text(text, style: BudgetronFonts.nunitoSize16Weight600);
  }

  Widget _resolveContainerSumValue(Map<EntryCategory, List<Entry>> entries) {
    var sum = entries.values
        .expand((element) => element.toList())
        .map((e) => e.value)
        .reduce((value, element) => value + element)
        .toStringAsFixed(2);

    return Text(
      "$sum $currency",
      style: BudgetronFonts.nunitoSize16Weight600,
    );
  }
}

class EntryListTile extends StatelessWidget {
  final ValueNotifier<bool> isExpandedListenable = ValueNotifier(false);
  final DatePeriod datePeriod;
  final EntryCategory category;
  final List<Entry> entries;
  final bool isExpandable;

  EntryListTile({
    super.key,
    required this.entries,
    required this.category,
    required this.isExpandable,
    required this.datePeriod,
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).colorScheme.surface),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.square_rounded,
                                size: 18,
                                color: CategoryService.stringToColor(
                                    category.color),
                              ),
                              const SizedBox(width: 8),
                              _resolveTileName()
                            ],
                          ),
                          Text(
                            _resolveSum(),
                            style: BudgetronFonts.nunitoSize16Weight400,
                          )
                        ],
                      ),
                    ],
                  ),
                )),
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

  _toggleExpandedView() =>
      isExpandedListenable.value = !isExpandedListenable.value;

  _resolveTileName() {
    return Row(
      children: [
        Text(category.name, style: BudgetronFonts.nunitoSize16Weight400),
        const SizedBox(width: 4),
        isExpandable && entries.length > 1
            ? Text("•", style: BudgetronFonts.nunitoSize8Weight300)
            : const SizedBox()
      ],
    );
  }

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
              color: Theme.of(context).colorScheme.surface),
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
                ExpandedEntryTile(entry: entries[index]),
          ));
    } else {
      return const SizedBox();
    }
  }
}

class ExpandedEntryTile extends StatelessWidget {
  final Entry entry;

  const ExpandedEntryTile({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => EditEntryPage(entry: entry)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).colorScheme.background),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Column(
          children: [
            Text(DateFormat.Hm().format(entry.dateTime),
                style: BudgetronFonts.nunitoSize16Weight300Gray,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(entry.value.toStringAsFixed(2),
                style: BudgetronFonts.nunitoSize16Weight400,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
