import 'package:budgetron/models/account/account.dart';

import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/account/transfer.dart';
import 'package:budgetron/models/account/transaction.dart';

class AccountsController {
  static Account getAccount(int accountId) {
    Account? account = _getAccountBox().get(accountId);
    if (account == null) {
      throw Exception('Account not found EC-303');
    }

    return account;
  }

  static Stream<List<Account>> getAccounts() {
    return _getAccountBox()
        .query()
        .order(Account_.id, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static int addAccount(Account account) => _getAccountBox().put(account);

  static void deleteAccount(int accountId) =>
      _getAccountBox().remove(accountId);

  static void addTransfer(Transfer transfer) => _getTransferBox().put(transfer);

  static void addTransaction(Transaction transaction) =>
      _getTransactionBox().put(transaction);

  static getTransactionsInPeriod(int accountId, List<DateTime> dates) {
    var periodCondition =
        Transaction_.dateTime.greaterOrEqual(dates[0].millisecondsSinceEpoch) &
            Transaction_.dateTime.lessOrEqual(dates[1].millisecondsSinceEpoch);
    var accountCondition = Transaction_.account.equals(accountId);

    return _getTransactionBox()
        .query(accountCondition & periodCondition)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static getTransfersInPeriod(int accountId, List<DateTime> dates) {
    var periodCondition =
        Transfer_.dateTime.greaterOrEqual(dates[0].millisecondsSinceEpoch) &
            Transfer_.dateTime.lessOrEqual(dates[1].millisecondsSinceEpoch);
    var accountCondition = Transfer_.fromAccount.equals(accountId) |
        Transfer_.toAccount.equals(accountId);

    return _getTransferBox()
        .query(accountCondition & periodCondition)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Box<Account> _getAccountBox() => ObjectBox.store.box<Account>();
  static Box<Transfer> _getTransferBox() => ObjectBox.store.box<Transfer>();
  static Box<Transaction> _getTransactionBox() =>
      ObjectBox.store.box<Transaction>();
}
