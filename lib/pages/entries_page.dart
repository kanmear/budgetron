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
                return ListView(
                  children: [
                    for (var entry in snapshot.data!)
                      Card(
                        child: ListTile(
                          leading: entry.section.target!.isExpense
                              ? const Icon(Icons.money_off)
                              : const Icon(Icons.money),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.value.toString()),
                              Text(entry.dateTime.toString()),
                              Text(entry.section.target!.name)
                            ],
                          ),
                        ),
                      )
                  ],
                );
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
