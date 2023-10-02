import 'package:flutter/material.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/db/entry_controller.dart';

class LatestEntries extends StatelessWidget {
  const LatestEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Latest updates',
              style: BudgetronFonts.nunitoSize16Weight600,
            ),
          ),
          const SizedBox(height: 8),
          const EntriesListView()
        ],
      ),
    );
  }
}

class EntriesListView extends StatelessWidget {
  const EntriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Entry>>(
      stream: _getEntries(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          List<Entry> entries = snapshot.data!;

          return Column(children: [
            for (var entry in entries) EntryListTile(entry: entry)
          ]);
        } else {
          return const Center(child: Text('no data'));
        }
      },
    );
  }

  _getEntries() => EntryController.getLatestEntries();
}

class EntryListTile extends StatelessWidget {
  const EntryListTile({
    super.key,
    required this.entry,
  });

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Theme.of(context).colorScheme.surface),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.background))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              entry.category.target!.name,
              style: BudgetronFonts.nunitoSize16Weight400,
            ),
            Text(entry.value.toStringAsFixed(2),
                style: BudgetronFonts.nunitoSize16Weight400)
          ]),
        ),
      ),
    );
  }
}