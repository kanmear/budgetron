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
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.yMMMd().format(day),
                            style: BudgetronFonts.nunito16,
                          ),
                          Text(
                            entriesMap[day]!
                                .map((e) => e.value)
                                .reduce((value, element) => value + element)
                                .toString(),
                            style: BudgetronFonts.nunito16,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(children: [
                      for (var entry in entriesMap[day]!)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Row(
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
                                    style: BudgetronFonts.nunito16,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 2)
                          ],
                        ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              )
            ],
          )
      ],
    );
  }
}
