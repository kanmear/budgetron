import 'package:budgetron/logic/entries/entry_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/pages/entries/new_entry_page.dart';

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
        body: StreamBuilder<List<Entry>>(
            stream: objectBox.getEntries(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return EntriesListView(data: snapshot.data!);
              } else {
                return const Center(
                  child: Text("No entries in database"),
                );
              }
            }),
        floatingActionButton: BudgetronFloatingActionButtonWithPlus(
          onPressed: () => _navigateToEntryCreation(context, () => {}),
        ));
  }

  Future<void> _navigateToEntryCreation(
      BuildContext context, Function callback) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEntryPage()));

    if (!mounted) return;
    callback.call(result);
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

    //TODO entries with the same category should be squashed together
    return ListView.builder(
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
                      Text(
                        (entriesMap.keys.first == day &&
                                day ==
                                    DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day))
                            ? "Today"
                            : DateFormat.yMMMd().format(day),
                        style: BudgetronFonts.nunitoSize16Weight600,
                      ),
                      Text(
                        entriesMap[day]!
                            .map((e) => e.value)
                            .reduce((value, element) => value + element)
                            .toString(),
                        style: BudgetronFonts.nunitoSize16Weight600,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Column(children: [
                  for (var entry in entriesMap[day]!)
                    EntryListTile(entry: entry),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24)
      ],
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
                    color: Color(
                        int.parse(radix: 16, entry.category.target!.color)),
                  ),
                  const SizedBox(width: 8),
                  Text(entry.category.target!.name,
                      style: BudgetronFonts.nunitoSize16Weight400)
                ],
              ),
              Text(
                entry.value.toString(),
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
