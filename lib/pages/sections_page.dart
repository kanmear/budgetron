import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/popups/new_section_popup.dart';

class SectionPage extends StatelessWidget {
  const SectionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
        body: StreamBuilder<List<Section>>(
            stream: objectBox.getSections(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return ListView(
                  children: [
                    // rename entry to section
                    for (var section in snapshot.data!)
                      Card(
                          child: ListTile(
                              leading: section.isExpense
                                  ? const Icon(Icons.money_off)
                                  : const Icon(Icons.money),
                              title: Text(section.name),
                              onTap: () => selectSectionAndReturn(
                                  appState, section, context)))
                  ],
                );
              } else {
                return const Center(
                  child: Text("No sections in database"),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const NewSectionDialog()),
          child: const Icon(Icons.add),
        ));
  }

  selectSectionAndReturn(
      AppState appState, Section section, BuildContext context) {
    appState.updateSection(section);
    Navigator.pop(context);
  }
}
