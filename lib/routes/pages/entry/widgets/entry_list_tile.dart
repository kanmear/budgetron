import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/logic/category/category_service.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/enums/date_period.dart';

import 'package:budgetron/routes/pages/entry/edit_entry_page.dart';

import 'package:budgetron/ui/classes/list_tiles/list_tile.dart';

class EntryListTile extends StatelessWidget {
  final ValueNotifier<bool> isExpandedListenable = ValueNotifier(false);
  final DatePeriod datePeriod;
  final EntryCategory category;
  final List<Entry> entries;
  final bool isExpandable;
  final ThemeData theme;

  EntryListTile({
    super.key,
    required this.entries,
    required this.category,
    required this.isExpandable,
    required this.datePeriod,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: isExpandedListenable,
      builder: (context, isExpanded, child) {
        return Column(
          children: [
            _resolveWrapperWidget(
              context,
              CustomListTile(
                leadingIcon: _getLeadingIcon(),
                leadingString: category.name,
                leadingOption: _resolveLeadingOption(),
                trailingString: _calculateSum(),
                decoration: isExpanded
                    ? BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8)))
                    : null,
              ),
            ),
            _resolveExpandedView(context),
          ],
        );
      },
    );
  }

  _resolveWrapperWidget(BuildContext context, Widget child) {
    if (datePeriod != DatePeriod.day) {
      return SizedBox(child: child);
    }

    return InkWell(
        onTap: (isExpandable && entries.length > 1)
            ? () => _toggleExpandedView()
            : () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    EditEntryPage(entry: entries.first)),
        child: child);
  }

  _getLeadingIcon() => Icon(
        Icons.square_rounded,
        size: 18,
        color: CategoryService.stringToColor(category.color),
      );

  _resolveLeadingOption() => isExpandable && entries.length > 1
      ? Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary)
      : const SizedBox();

  _toggleExpandedView() =>
      isExpandedListenable.value = !isExpandedListenable.value;

  _calculateSum() {
    return entries
        .map((entry) => entry.value)
        .reduce((value, element) => value + element)
        .toStringAsFixed(2);
  }

  _resolveExpandedView(BuildContext context) {
    if (isExpandedListenable.value && entries.length > 1) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              color: theme.colorScheme.surfaceContainerLowest),
          padding: const EdgeInsets.only(left: 8, right: 10, bottom: 8),
          //APPROACH is there a better way to handle 'RenderBox was not laid out'?
          //HACK height value is taken from design
          height: 76,
          child: ListView.separated(
            itemCount: entries.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) =>
                ExpandedEntryTile(entry: entries[index], theme: theme),
          ));
    } else {
      return const SizedBox();
    }
  }
}

class ExpandedEntryTile extends StatelessWidget {
  final Entry entry;
  final ThemeData theme;

  const ExpandedEntryTile({
    super.key,
    required this.entry,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => EditEntryPage(entry: entry)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat.Hm().format(entry.dateTime),
                style: theme.textTheme.labelMedium!
                    .apply(color: theme.colorScheme.surfaceContainerHigh),
                textAlign: TextAlign.center),
            Text(entry.value.toStringAsFixed(2),
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
