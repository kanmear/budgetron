import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/ui/icons.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/pages/entry/new_entry_page.dart';

class EntriesPage extends StatefulWidget {
  const EntriesPage({
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
            Flexible(
              child: StreamBuilder<List<Entry>>(
                  stream: EntryController.getEntries(),
                  builder: (context, snapshot) {
                    if (snapshot.data?.isNotEmpty ?? false) {
                      return EntriesListView(data: snapshot.data!);
                    } else {
                      return const Center(
                        child: Text("No entries in database"),
                      );
                    }
                  }),
            ),
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
  final List<Entry> data;

  const EntriesListView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Entry>> entriesMap = {};
    List<DateTime> entryDates = [];

    EntryService.formEntriesData(data, entriesMap, entryDates);

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: entryDates.length,
      itemBuilder: (context, index) {
        var day = entryDates[index];

        return EntryListTileContainer(entriesMap: entriesMap, day: day);
      },
    );
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Card(
            elevation: 3,
            shadowColor: entriesMap.keys.first == day
                ? const Color.fromARGB(25, 0, 0, 0)
                : Colors.transparent,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
          ),
        ),
        const SizedBox(height: 24)
      ],
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

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 10.0),
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
          const SizedBox(height: 8.0)
        ],
      ),
    );
  }
}
