import 'package:rxdart/rxdart.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/utils/date_utils.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/models/account/transfer.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/models/account/transaction.dart';
import 'package:budgetron/logic/settings/settings_service.dart';

class AccountService {
  static void createAccount(Account account) {
    int accountId = AccountsController.addAccount(account);

    if (account.isDefault) setDefaultAccount(accountId);
  }

  static void updateAccount(Account account) {
    AccountsController.addAccount(account);

    if (account.isDefault) setDefaultAccount(account.id);
  }

  static Stream<List<Listable>> getOperationsInPeriod(
      int accountId, List<DateTime> dates) {
    Stream<List<Listable>> entries = EntryController.getEntries(
        period: [dates.first, dates.last], accountId: accountId);
    Stream<List<Listable>> transactions =
        getTransactionsInPeriod(accountId, dates);
    Stream<List<Listable>> transfers = getTransfersInPeriod(accountId, dates);

    //NOTE this looks like ass, but does the trick
    return CombineLatestStream.list([entries, transfers, transactions])
        .map((list) => list.expand((list) => list).toList());
  }

  static void createTransfer(Transfer transfer) {
    Account fromAccount = transfer.fromAccount.target!;
    fromAccount.balance -= transfer.value;
    AccountsController.addAccount(fromAccount);

    Account toAccount = transfer.toAccount.target!;
    toAccount.balance += transfer.value;
    AccountsController.addAccount(toAccount);

    AccountsController.addTransfer(transfer);
  }

  static void createTransaction(Transaction transaction) {
    Account receiverAccount = transaction.account.target!;
    receiverAccount.balance += transaction.value;
    AccountsController.addAccount(receiverAccount);

    AccountsController.addTransaction(transaction);
  }

  static getTransactionsInPeriod(int accountId, List<DateTime> dates) {
    return AccountsController.getTransactionsInPeriod(accountId, dates);
  }

  static getTransfersInPeriod(int accountId, List<DateTime> dates) {
    return AccountsController.getTransfersInPeriod(accountId, dates);
  }

  static void formOperationsData(
      DatePeriod datePeriod,
      List<Listable> operations,
      Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap,
      Map<DateTime, List<Listable>> otherOperationsMap,
      List<DateTime> entryDates) {
    for (var operation in operations) {
      if (operation is Entry) {
        EntryService.addEntryToMap(entriesMap, operation, datePeriod);
      } else {
        _addOperationToMap(otherOperationsMap, operation, datePeriod);
      }
    }

    Set<DateTime> setOfDates = Set.from(entriesMap.keys);
    setOfDates.addAll(otherOperationsMap.keys);

    var sortedDates = setOfDates.toList();
    sortedDates.sort((a, b) => b.compareTo(a));
    entryDates.addAll(sortedDates);
  }

  static void _addOperationToMap(Map<DateTime, List<Listable>> operationsMap,
      Listable operation, DatePeriod datePeriod) {
    DateTime dateTime = datePeriod == DatePeriod.day
        ? BudgetronDateUtils.stripTime(operation.dateTime)
        : DateTime(operation.dateTime.year, operation.dateTime.month);

    if (operationsMap.containsKey(dateTime)) {
      List<Listable> currentOperations = operationsMap[dateTime]!;
      currentOperations.add(operation);

      operationsMap.update(dateTime, (value) => currentOperations);
    } else {
      operationsMap[dateTime] = List.from({operation});
    }
  }

  static void setDefaultAccount(int id) =>
      SettingsService.setDefaultAccountId(id);
}
