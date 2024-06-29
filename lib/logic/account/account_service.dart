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
    var wasDefault = AccountsController.getAccount(account.id).isDefault;

    if (account.isDefault && !wasDefault) {
      setDefaultAccount(account.id);
    } else if (!account.isDefault && wasDefault) {
      SettingsService.setDefaultAccountId(-1);
    }

    AccountsController.addAccount(account);
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

    _updateEarliestDate(fromAccount, transfer.dateTime);
    AccountsController.addAccount(fromAccount);

    Account toAccount = transfer.toAccount.target!;
    toAccount.balance += transfer.value;

    _updateEarliestDate(toAccount, transfer.dateTime);
    AccountsController.addAccount(toAccount);

    AccountsController.addTransfer(transfer);
  }

  static void createTransaction(Transaction transaction) {
    Account account = transaction.account.target!;
    account.balance += transaction.value;

    _updateEarliestDate(account, transaction.dateTime);
    AccountsController.addAccount(account);

    AccountsController.addTransaction(transaction);
  }

  static void updateEarliestDate(Account account, DateTime operationDate) {
    if (_updateEarliestDate(account, operationDate)) updateAccount(account);
  }

  static bool _updateEarliestDate(Account account, DateTime operationDate) {
    if (!operationDate.isBefore(account.earliestOperationDate)) {
      return false;
    }

    account.earliestOperationDate = operationDate;
    return true;
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
    DateTime dateTime;
    switch (datePeriod) {
      case DatePeriod.day:
        dateTime = BudgetronDateUtils.stripTime(operation.dateTime);
        break;
      case DatePeriod.month:
        dateTime = DateTime(operation.dateTime.year, operation.dateTime.month);
        break;
      case DatePeriod.year:
        dateTime = DateTime(operation.dateTime.year);
        break;
      default:
        throw Exception('Not a valid date period.');
    }

    if (operationsMap.containsKey(dateTime)) {
      List<Listable> currentOperations = operationsMap[dateTime]!;
      currentOperations.add(operation);

      operationsMap.update(dateTime, (value) => currentOperations);
    } else {
      operationsMap[dateTime] = List.from({operation});
    }
  }

  static void setDefaultAccount(int id) async {
    SettingsService.setDefaultAccountId(id);

    var accounts = await AccountsController.getAccounts().first;
    for (var account in accounts) {
      if (account.isDefault && account.id != id) {
        account.isDefault = false;
        AccountsController.addAccount(account);

        return;
      }
    }
  }
}
