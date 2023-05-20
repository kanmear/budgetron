import 'package:flutter/material.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/popups/new_entry_popup.dart';

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
              Text(day.toString()),
              Column(children: [
                for (var entry in entriesMap[day]!)
                  Card(
                    child: ListTile(
                      leading: entry.category.target!.isExpense
                          ? const Icon(Icons.money_off)
                          : const Icon(Icons.money),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.value.toString()),
                            Text(entry.category.target!.name)
                          ]),
                    ),
                  )
              ]),
            ],
          )
      ],
    );

    // return ListView(
    //   children: [
    //     for (var entry in data)
    //       Card(
    //         child: ListTile(
    //           leading: entry.category.target!.isExpense
    //               ? const Icon(Icons.money_off)
    //               : const Icon(Icons.money),
    //           title: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(entry.value.toString()),
    //               Text(entry.dateTime.toString()),
    //               Text(entry.category.target!.name)
    //             ],
    //           ),
    //         ),
    //       )
    //   ],
    // );
  }
}
