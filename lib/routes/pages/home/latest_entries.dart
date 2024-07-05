import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/db/entry_controller.dart';

class LatestEntries extends StatelessWidget {
  const LatestEntries({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Latest transactions',
                style: theme.textTheme.headlineMedium),
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
    final theme = Theme.of(context);

    return StreamBuilder<List<Entry>>(
      stream: _getEntries(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          List<Entry> entries = snapshot.data!;

          return Column(children: [
            for (var entry in entries) EntryListTile(entry: entry)
          ]);
        } else {
          return Center(
              child: Text('No entries in database',
                  style: theme.textTheme.bodyMedium!
                      .apply(color: theme.colorScheme.surfaceContainerHigh)));
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
    final theme = Theme.of(context);

    final currency = Provider.of<AppData>(context).currency;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: theme.colorScheme.surfaceContainerLowest),
      child: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: theme.colorScheme.surface))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.category.target!.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text("${entry.value.toStringAsFixed(2)} $currency",
                      style: theme.textTheme.bodyMedium)
                ]),
          )),
    );
  }
}
