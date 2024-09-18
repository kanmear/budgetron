import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/app_data.dart';

import 'package:budgetron/logic/account/account_service.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/enums/date_period.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/date_selector_legacy.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';

import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/utils/date_utils.dart';

import 'package:budgetron/routes/pages/entry/entries_page.dart';

class LegacyAccountOperationsPage extends StatelessWidget {
  final Account account;
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.day);
  final ValueNotifier<List<DateTime>> dateTimeNotifier = ValueNotifier(
      BudgetronDateUtils.calculateDateRange(BudgetronPage.accounts));

  LegacyAccountOperationsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    final currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return Scaffold(
        appBar: const BudgetronAppBar(
            leading: ArrowBackIconButton(), title: 'Operations'),
        backgroundColor: theme.colorScheme.surface,
        body: Column(children: [
          OperationsListView(
              account: account,
              dateTimeNotifier: dateTimeNotifier,
              datePeriodNotifier: datePeriodNotifier,
              currency: currency,
              theme: theme),
          LegacyDateSelector(datePeriodNotifier: datePeriodNotifier)
        ]));
  }
}

class OperationsListView extends StatelessWidget {
  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final Account account;
  final String currency;
  final ThemeData theme;

  const OperationsListView(
      {super.key,
      required this.dateTimeNotifier,
      required this.currency,
      required this.datePeriodNotifier,
      required this.account,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: StreamBuilder<List<Listable>>(
            stream: _getOperations(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return ValueListenableBuilder(
                    valueListenable: datePeriodNotifier,
                    builder: (context, value, child) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: _buildListView(snapshot.data!, currency));
                    });
              } else {
                return Center(
                    child: Text(
                  'No entries in database',
                  style: theme.textTheme.bodyMedium!
                      .apply(color: theme.colorScheme.surfaceContainerHigh),
                ));
              }
            }));
  }

  Stream<List<Listable>> _getOperations() {
    var fromDate = account.earliestOperationDate;
    var toDate = DateTime.now();

    return AccountService.getOperationsInPeriod(account.id, [fromDate, toDate]);
  }

  Widget _buildListView(List<Listable> operations, String currency) {
    Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap = {};
    Map<DateTime, List<Listable>> otherOperationsMap = {};
    List<DateTime> entryDates = [];

    DatePeriod datePeriod = datePeriodNotifier.value;

    AccountService.formOperationsData(
        datePeriod, operations, entriesMap, otherOperationsMap, entryDates);

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: entryDates.length,
      itemBuilder: (context, index) {
        var groupingDate = entryDates[index];

        var entriesOrEmpty = entriesMap.containsKey(groupingDate)
            ? entriesMap[groupingDate]!
            : <EntryCategory, List<Entry>>{};
        List<Listable> operationsOrEmpty =
            otherOperationsMap.containsKey(groupingDate)
                ? otherOperationsMap[groupingDate]!
                : [];
        operationsOrEmpty.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        return OperationListTileContainer(
            entriesToCategoryMap: entriesOrEmpty,
            operations: operationsOrEmpty,
            groupingDate: groupingDate,
            datePeriod: datePeriod,
            currency: currency,
            theme: theme);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              SizedBox(height: 16),
              HorizontalSeparator(),
              SizedBox(height: 16)
            ],
          ),
        );
      },
    );
  }
}

class OperationListTileContainer extends StatelessWidget {
  final Map<EntryCategory, List<Entry>> entriesToCategoryMap;
  final List<Listable> operations;
  final DatePeriod datePeriod;
  final String currency;
  final DateTime groupingDate;
  final ThemeData theme;

  const OperationListTileContainer({
    super.key,
    required this.entriesToCategoryMap,
    required this.groupingDate,
    required this.datePeriod,
    required this.currency,
    required this.operations,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _resolveContainerTitle(),
                    _resolveContainerSumValue()
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(children: [
                for (var category in entriesToCategoryMap.keys)
                  Column(
                    children: [
                      EntryListTile(
                          category: category,
                          entries: entriesToCategoryMap[category]!,
                          isExpandable: datePeriod == DatePeriod.day,
                          datePeriod: datePeriod,
                          theme: theme),
                      const SizedBox(height: 8),
                    ],
                  ),
                for (var operation in operations)
                  OperationListTile(operation: operation, theme: theme)
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resolveContainerTitle() {
    //if grouped by day and containers date is today => display today
    DateTime now = DateTime.now();

    if (datePeriod == DatePeriod.day &&
        BudgetronDateUtils.stripTime(groupingDate) ==
            BudgetronDateUtils.stripTime(now)) {
      return Text(
        'Today',
        style: theme.textTheme.bodySmall,
      );
    }

    String text;
    switch (datePeriod) {
      case DatePeriod.day:
        text = DateFormat.yMMMd().format(groupingDate);
        break;
      case DatePeriod.month:
        text = DateFormat.yMMM().format(groupingDate);
        break;
      case DatePeriod.year:
        text = DateFormat.y().format(groupingDate);
        break;
      default:
        throw Exception('Not a valid date period.');
    }

    return Text(text, style: theme.textTheme.bodySmall);
  }

  Widget _resolveContainerSumValue() {
    double sum = 0;

    if (entriesToCategoryMap.values.isNotEmpty) {
      sum += entriesToCategoryMap.values
          .expand((element) => element.toList())
          .map((e) => e.value)
          .reduce((value, element) => value + element);
    }
    if (operations.isNotEmpty) {
      sum += operations
          .map((e) => e.value)
          .reduce((value, element) => value + element);
    }

    return Text(
      "${sum.toStringAsFixed(2)} $currency",
      style: theme.textTheme.bodySmall,
    );
  }
}

class OperationListTile extends StatelessWidget {
  final Listable operation;
  final ThemeData theme;

  const OperationListTile(
      {super.key, required this.operation, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerLowest),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                operation.toString(),
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                operation.value.toStringAsFixed(2),
                style: theme.textTheme.bodyMedium,
              )
            ],
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}
