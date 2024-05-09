import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/ui/classes/date_selector_entries.dart';
import 'package:budgetron/routes/popups/entry/edit_entry_popup.dart';

class EntriesPage extends StatefulWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.day);

  EntriesPage({
    super.key,
  });

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppData>(context).currency;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          EntriesListView(
              datePeriodNotifier: widget.datePeriodNotifier,
              currency: currency),
          DateSelectorEntries(datePeriodNotifier: widget.datePeriodNotifier)
        ]));
  }
}

class EntriesListView extends StatelessWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final String currency;

  const EntriesListView(
      {super.key, required this.datePeriodNotifier, required this.currency});

  @override
  Widget build(BuildContext context) {
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
                  "No entries in database",
                  style: BudgetronFonts.nunitoSize16Weight300Gray,
                ));
              }
            }));
  }

  _buildListView(List<Entry> entries, String currency) {
    Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap = {};
    List<DateTime> entryDates = [];

    DatePeriod datePeriod = datePeriodNotifier.value;

    EntryService.formEntriesData(datePeriod, entries, entriesMap, entryDates);

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: entryDates.length,
      itemBuilder: (context, index) {
        var day = entryDates[index];

        return EntryListTileContainer(
            entriesMap: entriesMap,
            day: day,
            datePeriod: datePeriod,
            datePeriodNotifier: datePeriodNotifier,
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
  final Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final DatePeriod datePeriod;
  final String currency;
  final DateTime day;

  const EntryListTileContainer({
    super.key,
    required this.entriesMap,
    required this.day,
    required this.datePeriod,
    required this.datePeriodNotifier,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    Map<EntryCategory, List<Entry>> entries = entriesMap[day]!;

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
                    _resolveContainerSumValue(entries)
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(children: [
                for (var key in entries.keys)
                  EntryListTile(
                    category: key,
                    entries: entries[key]!,
                    isExpandable: datePeriod == DatePeriod.day,
                    datePeriodNotifier: datePeriodNotifier,
                  ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resolveContainerTitle() {
    if (entriesMap.keys.first == day) {
      DateTime now = DateTime.now();

      if (datePeriod == DatePeriod.day &&
          day == DateTime(now.year, now.month, now.day)) {
        return Text(
          "Today",
          style: BudgetronFonts.nunitoSize16Weight600,
        );
      }
    }

    return Text(
        datePeriod == DatePeriod.day
            ? DateFormat.yMMMd().format(day)
            : DateFormat.yMMM().format(day),
        style: BudgetronFonts.nunitoSize16Weight600);
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
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final EntryCategory category;
  final List<Entry> entries;
  final bool isExpandable;

  EntryListTile({
    super.key,
    required this.entries,
    required this.category,
    required this.isExpandable,
    required this.datePeriodNotifier,
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
                  padding: const EdgeInsets.only(
                      left: 8, right: 10, top: 8, bottom: 8),
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
            const SizedBox(height: 8)
          ],
        );
      },
    );
  }

  _resolveWrapperWidget(BuildContext context, Widget child) {
    if (datePeriodNotifier.value != DatePeriod.day) {
      return SizedBox(child: child);
    }

    return InkWell(
        onTap: (isExpandable && entries.length > 1)
            ? () => _toggleExpandedView()
            : () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    EditEntryDialog(entry: entries.first)),
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
          builder: (BuildContext context) => EditEntryDialog(entry: entry)),
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
