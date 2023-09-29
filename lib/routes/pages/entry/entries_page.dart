import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/pages/entry/new_entry_page.dart';

class EntriesPage extends StatefulWidget {
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.month);

  EntriesPage({
    super.key,
  });

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            const BudgetronAppBarWithTitle(
                title: 'Entries',
                leftIconButton: MenuIconButton(),
                rightIconButton: EditIconButton()),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            const EntriesListView(),
          ],
        ),
        floatingActionButton: BudgetronFloatingActionButtonWithPlus(
          onPressed: () => _navigateToEntryCreation(context),
        ));
  }

  Future<void> _navigateToEntryCreation(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEntryPage()));

    if (!mounted) return;
  }
}

class EntriesListView extends StatelessWidget {
  const EntriesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: StreamBuilder<List<Entry>>(
            stream: EntryController.getEntries(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                Map<DateTime, List<Entry>> entriesMap = {};
                List<DateTime> entryDates = [];

                EntryService.formEntriesData(
                    snapshot.data!, entriesMap, entryDates);

                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: entryDates.length,
                    itemBuilder: (context, index) {
                      var day = entryDates[index];

                      return EntryListTileContainer(
                          entriesMap: entriesMap, day: day);
                    });
              } else {
                return const Center(child: Text("No entries in database"));
              }
            }));
  }
}

class EntryListTileContainer extends StatelessWidget {
  const EntryListTileContainer({
    super.key,
    required this.entriesMap,
    required this.day,
  });

  final Map<DateTime, List<Entry>> entriesMap;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    List<Entry> entries = entriesMap[day]!;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
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
                  for (var entry in entries) EntryListTile(entry: entry),
                ]),
              ],
            ),
            const SizedBox(height: 16),
            const HorizontalSeparator(),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }

  Widget _resolveContainerTitle() {
    if (entriesMap.keys.first == day) {
      DateTime now = DateTime.now();

      if (day == DateTime(now.year, now.month, now.day)) {
        return Text(
          "Today",
          style: BudgetronFonts.nunitoSize16Weight600,
        );
      }
    }

    return Text(DateFormat.yMMMd().format(day),
        style: BudgetronFonts.nunitoSize16Weight600);
  }

  Widget _resolveContainerSumValue(List<Entry> entries) {
    return Text(
      entries
          .map((e) => e.value)
          .reduce((value, element) => value + element)
          .toStringAsFixed(2),
      style: BudgetronFonts.nunitoSize16Weight600,
    );
  }
}

class EntryListTile extends StatelessWidget {
  const EntryListTile({
    super.key,
    required this.entry,
  });

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    EntryCategory category = entry.category.target!;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).colorScheme.surface),
          padding: const EdgeInsets.only(left: 8, right: 10, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.square_rounded,
                    size: 18,
                    color: CategoryService.stringToColor(category.color),
                  ),
                  const SizedBox(width: 8),
                  Text(category.name,
                      style: BudgetronFonts.nunitoSize16Weight400)
                ],
              ),
              Text(
                entry.value.toStringAsFixed(2),
                style: BudgetronFonts.nunitoSize16Weight400,
              )
            ],
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}
