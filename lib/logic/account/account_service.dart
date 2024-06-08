import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/logic/settings/settings_service.dart';

class AccountService {
  static void createAccount(Account account) {
    int accountId = AccountsController.addAccount(account);

    if (account.isDefault) setDefaultAccount(accountId);
  }

  static void setDefaultAccount(int id) =>
      SettingsService.setDefaultAccountId(id);
}
