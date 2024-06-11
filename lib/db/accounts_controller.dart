import 'package:budgetron/models/account/account.dart';

import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/account/transfer.dart';
import 'package:budgetron/objectbox.g.dart';

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

  static Box<Account> _getAccountBox() => ObjectBox.store.box<Account>();
  static Box<Transfer> _getTransferBox() => ObjectBox.store.box<Transfer>();
}
