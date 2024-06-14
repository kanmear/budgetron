import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/models/account/transfer.dart';
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

  static void setDefaultAccount(int id) =>
      SettingsService.setDefaultAccountId(id);
}
