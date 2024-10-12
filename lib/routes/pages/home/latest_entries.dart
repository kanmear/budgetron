import 'package:budgetron/logic/category/category_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/currency.dart';

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

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerLowest,
            ),
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(children: [
              for (var entry in entries)
                EntryListTile(entry: entry, isLast: entry == entries.last)
            ]),
          );
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
  final Entry entry;
  final bool isLast;

  const EntryListTile({
    super.key,
    required this.entry,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    String currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;
    final category = entry.category.target!;

    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isLast
                        ? Colors.transparent
                        : theme.colorScheme.surfaceContainerLow))),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                fit: FlexFit.loose,
                child: Row(
                  children: [
                    Icon(
                      Icons.square_rounded,
                      size: 18,
                      color: CategoryService.stringToColor(category.color),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        entry.category.target!.name,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: Text(
                      entry.value.toStringAsFixed(2),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  //HACK text with space
                  Text(' ', style: theme.textTheme.bodyMedium),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Text(
                      currency,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  )
                ]),
              )
            ],
          ),
        ));
  }
}
