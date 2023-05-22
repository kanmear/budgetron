import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/popups/new_entry_popup.dart';
import 'package:intl/intl.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const EntryDialog()),
          child: const Icon(Icons.add),
        ));
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

    void addEntryToMap(Entry entry) {
      DateTime dateTime = DateTime(
          entry.dateTime.year, entry.dateTime.month, entry.dateTime.day);
      if (entriesMap.containsKey(dateTime)) {
        entriesMap.update(
            dateTime, (value) => List.from(value)..addAll({entry}));
      } else {
        entriesMap[dateTime] = List.from({entry});
      }
    }

    for (var element in data) {
      addEntryToMap(element);
    }

    return ListView(
      children: [
        for (var day in entriesMap.keys)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat.yMMMd().format(day),
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.square_rounded,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(entry.category.target!.name)
                                      ],
                                    ),
                                    Text(
                                      entry.value.toString(),
                                      style:
                                          BudgetronFonts.nunitoSize16Weight400,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8.0)
                              ],
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24)
            ],
          )
      ],
    );
  }
}
