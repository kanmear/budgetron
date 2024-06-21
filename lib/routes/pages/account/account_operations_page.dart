import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/logic/account/account_service.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/ui/classes/date_selector.dart';
import 'package:budgetron/ui/classes/date_selector_legacy.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/utils/interfaces.dart';

class AccountOperationsPage extends StatelessWidget {
  final Account account;
  final ValueNotifier<DatePeriod> datePeriodNotifier =
      ValueNotifier(DatePeriod.day);
  final ValueNotifier<List<DateTime>> dateTimeNotifier =
      ValueNotifier(BudgetronDateUtils.getDatesInPeriod(BudgetronPage.entries));

  AccountOperationsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final isLegacy = appData.legacyDateSelector;

    return Scaffold(
        appBar: const BudgetronAppBar(
            leading: ArrowBackIconButton(), title: 'Operations'),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          OperationsListView(
              account: account,
              dateTimeNotifier: dateTimeNotifier,
              datePeriodNotifier: datePeriodNotifier,
              currency: appData.currency,
              isLegacy: isLegacy),
          _resolveDateSelector(isLegacy)
        ]));
  }

  Widget _resolveDateSelector(bool legacyDateSelector) {
    if (legacyDateSelector) {
      return LegacyDateSelector(datePeriodNotifier: datePeriodNotifier);
    } else {
      return DateSelector(
        datePeriodNotifier: datePeriodNotifier,
        dateTimeNotifier: dateTimeNotifier,
        earliestDate: account.earliestOperationDate,
        periodItems: const [DatePeriod.day, DatePeriod.month, DatePeriod.year],
      );
    }
  }
}

class OperationsListView extends StatelessWidget {
  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final Account account;
  final String currency;
  final bool isLegacy;

  const OperationsListView(
      {super.key,
      required this.dateTimeNotifier,
      required this.currency,
      required this.datePeriodNotifier,
      required this.isLegacy,
      required this.account});

  @override
  Widget build(BuildContext context) {
    return _resolveBody(isLegacy);
  }

  Widget _resolveBody(bool isLegacy) {
    if (isLegacy) {
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
                    style: BudgetronFonts.nunitoSize16Weight300Gray,
                  ));
                }
              }));
    } else {
      return Flexible(
          child: ValueListenableBuilder(
              valueListenable: dateTimeNotifier,
              builder: (context, value, child) {
                return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: StreamBuilder<List<Listable>>(
                        stream: _getOperationsInPeriod(),
                        builder: (context, snapshot) {
                          if (snapshot.data?.isNotEmpty ?? false) {
                            return _buildListView(snapshot.data!, currency);
                          } else {
                            return Center(
                                child: Text(
                              'No entries for this period',
                              style: BudgetronFonts.nunitoSize16Weight300Gray,
                            ));
                          }
                        }));
              }));
    }
  }

  Stream<List<Listable>> _getOperations() {
    var fromDate = account.earliestOperationDate;
    var toDate = DateTime.now();

    return AccountService.getOperationsInPeriod(account.id, [fromDate, toDate]);
  }

  Stream<List<Listable>> _getOperationsInPeriod() {
    var fromDate = dateTimeNotifier.value[0];
    var toDate = dateTimeNotifier.value[1];

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

        return OperationListTileContainer(
            entriesToCategoryMap: entriesOrEmpty,
            operations: operationsOrEmpty,
            groupingDate: groupingDate,
            datePeriod: datePeriod,
            currency: currency);
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

  const OperationListTileContainer({
    super.key,
    required this.entriesToCategoryMap,
    required this.groupingDate,
    required this.datePeriod,
    required this.currency,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
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
                  EntryListTile(
                    category: category,
                    entries: entriesToCategoryMap[category]!,
                    isExpandable: datePeriod == DatePeriod.day,
                    datePeriod: datePeriod,
                  ),
                for (var operation in operations)
                  OperationListTile(operation: operation)
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
        style: BudgetronFonts.nunitoSize16Weight600,
      );
    }

    //otherwise display date according to DateSelector
    return Text(
        datePeriod == DatePeriod.day
            ? DateFormat.yMMMd().format(groupingDate)
            : DateFormat.yMMM().format(groupingDate),
        style: BudgetronFonts.nunitoSize16Weight600);
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
      style: BudgetronFonts.nunitoSize16Weight600,
    );
  }
}

class OperationListTile extends StatelessWidget {
  final Listable operation;

  const OperationListTile({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Theme.of(context).colorScheme.surface),
      padding: const EdgeInsets.only(left: 8, right: 10, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            operation.toString(),
            style: BudgetronFonts.nunitoSize16Weight400,
          ),
          Text(
            operation.value.toStringAsFixed(2),
            style: BudgetronFonts.nunitoSize16Weight400,
          )
        ],
      ),
    );
  }
}